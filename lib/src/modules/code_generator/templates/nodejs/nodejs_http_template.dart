import 'dart:convert';
import 'dart:io';
import 'package:client_ao/src/modules/code_generator/templates/interfaces/codegen_template.interface.dart';
import 'package:client_ao/src/modules/code_generator/templates/nodejs/nodejs_http_jinja.dart';
import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:jinja/jinja.dart';

class NodejsWithHttpTemplate implements ICodeGenTemplate {
  /// Generate NodeJS code for [Packages.http]
  final RequestModel? request;

  NodejsWithHttpTemplate(this.request);

  @override
  void importAndRequestMethod() {
    String? url = request?.url;
    if (!(url?.contains("://") == true) && url?.isNotEmpty == true) {
      url = Protocol.https + url!;
    }

    if (url == null) return;

    final uri = Uri.parse(url);
    final method = request?.method.name.toUpperCase();

    final urlTemplate = Template(defaultNodejsHttpImportAndOptionsTemplate);
    output = urlTemplate.render({"method": method, "hostname": uri.host});
  }

  @override
  String? addBody() {
    final body = request?.body;
    if (body != null && request?.method != HttpVerb.get) {
      final contentLength = utf8.encode(body).length;
      if (contentLength > 0) {
        var templateBody = Template(defaultNodejsHttpBodyTemplate);
        final result = templateBody.render({"body": body});
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
        headersString = addPaddingToMultilineString(
          headersString,
          defaultNodejsHeadersPadding,
        );
        final templateHeaders = Template(defaultNodejsHttpHeadersTemplate);
        output = (output ?? '') + templateHeaders.render({"headers": headersString});
      }
    } else {
      output = (output ?? '') + defaultNodejsHttpEmptyHeadersTemplate;
    }

    return headersString;
  }

  @override
  String? addQueryParams() {
    var templateParams = Template(defaultNodejsHttpPathTemplate);
    final params = listToMap(request?.urlParams);

    final uri = Uri.tryParse(request?.url ?? '');
    String path = '';

    if (params != null && params.isNotEmpty && params.keys.first.isNotEmpty) {
      final newUri = uri?.replace(queryParameters: params);
      path = '${uri?.path}?${newUri?.query}';
    } else if (uri?.path != null && uri?.path.isNotEmpty == true) {
      path = uri?.path ?? '';
    } else {
      path = '/';
    }

    output = (output ?? '') + templateParams.render({"path": path});

    return output;
  }

  @override
  String? output;

  @override
  void requestEnd({bool? hasHeader, bool? hasBody}) {
    output = (output ?? '') + defaultNodejsHttpStringResponseResult;
  }

  @override
  String? build() {
    importAndRequestMethod();
    addQueryParams();
    final headers = addHeaders();
    requestEnd(
      hasHeader: headers?.isNotEmpty,
      hasBody: request?.body != null && request?.method != HttpVerb.get,
    );
    addBody();
    output = (output ?? '') + defaultNodejsHttpRequestEnd;
    return output;
  }
}
