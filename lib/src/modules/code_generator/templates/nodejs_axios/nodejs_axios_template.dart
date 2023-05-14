import 'dart:convert';
import 'dart:io';
import 'package:client_ao/src/modules/code_generator/templates/interfaces/codegen_template.interface.dart';
import 'package:client_ao/src/modules/code_generator/templates/nodejs_axios/nodejs_axios_jinja.dart';
import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/base_request.interface.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:jinja/jinja.dart';

class NodejsWithAxiosTemplate implements ICodeGenTemplate {
  /// Generate NodeJS code for [Packages.axios]
  final BaseRequestModel? request;

  NodejsWithAxiosTemplate(this.request);

  @override
  void importAndRequestMethod() {
    String? url = request?.url;
    if (!(url?.contains("://") == true) && url?.isNotEmpty == true) {
      url = Protocol.https + url!;
    }

    if (url == null) return;

    final uri = Uri.parse(url);
    final method = request?.method.name.toUpperCase();

    final urlTemplate = Template(defaultNodejsAxiosImportAndOptionsTemplate);
    output = urlTemplate.render({"method": method, "url": uri.toString()});
  }

  @override
  String? addBody() {
    final body = request?.body;
    if (body != null && request?.method != HttpVerb.get) {
      final contentLength = utf8.encode(body).length;
      if (contentLength > 0) {
        var templateBody = Template(defaultNodejsAxiosBodyTemplate);
        final result = templateBody.render({"data": body});
        output = (output ?? '') + result;
      }
    }
    return body;
  }

  @override
  String? addHeaders() {
    String headersString = '';
    var headers = listToMap(request?.headers) ?? {};

    if (output == null) return null;

    final hasBody = request?.body != null && request?.method != HttpVerb.get;
    if (headers.isNotEmpty || hasBody) {
      if (headers.isNotEmpty == true || hasBody) {
        if (hasBody) {
          final contentLength = utf8.encode(request?.body ?? '').length;
          headers[HttpHeaders.contentLengthHeader] = '$contentLength';
        }

        headersString = jsonEncoder.convert(headers);
        headersString = addPaddingToMultilineString(headersString, 4);
        final templateHeaders = Template(defaultNodejsAxiosHeadersTemplate);
        output = (output ?? '') + templateHeaders.render({"headers": headersString});
      }
    } else {
      output = (output ?? '') + defaultNodejsAxiosEmptyHeadersTemplate;
    }

    return headersString;
  }

  @override
  String? addQueryParams() {
    var templateParams = Template(defaultNodejsAxiosPathTemplate);
    final params = listToMap(request?.urlParams);

    if (params != null && params.isNotEmpty && params.keys.first.isNotEmpty) {
      var paramsString = jsonEncoder.convert(params);
      paramsString = addPaddingToMultilineString(paramsString, 4);

      output = (output ?? '') + templateParams.render({"params": paramsString});
    }

    return output;
  }

  @override
  String? output;

  @override
  void requestEnd({bool? hasHeader, bool? hasBody}) {
    output = (output ?? '') + defaultNodejsAxiosStringResponseResult;
  }

  @override
  String? build() {
    importAndRequestMethod();
    addQueryParams();
    addBody();
    final headers = addHeaders();
    requestEnd(
      hasHeader: headers?.isNotEmpty,
      hasBody: request?.body != null && request?.method != HttpVerb.get,
    );
    return output;
  }
}
