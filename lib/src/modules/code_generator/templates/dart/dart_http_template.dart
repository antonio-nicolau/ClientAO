import 'dart:convert';
import 'dart:io';
import 'package:client_ao/src/modules/code_generator/templates/dart/dart_http_jinja.dart';
import 'package:client_ao/src/modules/code_generator/templates/interfaces/codegen_template.interface.dart';
import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:jinja/jinja.dart';

class DartWithHttpTemplate implements ICodeGenTemplate {
  /// Generate Dart code for [Packages.http]
  final RequestModel? request;

  DartWithHttpTemplate(this.request);

  @override
  String? addBody() {
    final body = request?.body;
    if (body != null && request?.method != HttpVerb.get) {
      final contentLength = utf8.encode(body).length;
      if (contentLength > 0) {
        var templateBody = Template(defaultTemplateBody);
        final result = templateBody.render({"body": body});
        output = defaultDartConvertImport + (output ?? '');
        output = (output ?? '') + result;
        output = (output ?? '') + defaultBodyLength;
      }
    }
    return body;
  }

  @override
  String? addHeaders() {
    String headersString = '';
    var headers = listToMap(request?.headers) ?? {};

    final hasBody = request?.body != null && request?.method != HttpVerb.get;
    if (headers.isNotEmpty || hasBody) {
      if (headers.isNotEmpty == true || hasBody) {
        if (hasBody) {
          headers[HttpHeaders.contentLengthHeader] = r"$contentLength";
        }

        headersString = jsonEncoder.convert(headers);
        headersString = addPaddingToMultilineString(headersString, defaultHeadersPadding);
        final templateHeaders = Template(defaultTemplateHeaders);
        output = (output ?? '') + templateHeaders.render({"headers": headersString});
      }
    }

    return headersString;
  }

  @override
  String? addQueryParams() {
    var templateParams = Template(defaultParamsTemplate);
    String? url = request?.url;

    final params = listToMap(request?.urlParams);
    if (params != null && params.isNotEmpty && params.keys.first.isNotEmpty) {
      var paramsString = jsonEncoder.convert(params);
      paramsString = addPaddingToMultilineString(paramsString, defaultParamsPadding);

      output = (output ?? '') + templateParams.render({"params": paramsString});
      Uri uri = Uri.parse(url!);
      if (uri.hasQuery) {
        output = (output ?? '') + defaultStringWithUrlParams;
      } else {
        output = (output ?? '') + defaultStringWithNoUrlParams;
      }
    }

    return output;
  }

  @override
  void importAndRequestMethod() {
    String? url = request?.url;
    if (!(url?.contains("://") == true) && url?.isNotEmpty == true) {
      url = Protocol.https + url!;
    }

    final urlTemplate = Template(defaultHttpImportAndUriTemplate);
    output = urlTemplate.render({"url": url});
  }

  @override
  String? output;

  @override
  void requestEnd({bool? hasHeader, bool? hasBody}) {
    var templateRequest = Template(defaultTemplateRequest);
    output = (output ?? '') + templateRequest.render({"method": request?.method.name});

    if (hasHeader == true) {
      output = (output ?? '') + defaultStringRequestHeaders;
    }
    if (hasBody == true) {
      output = (output ?? '') + defaultStringRequestBody;
    }

    output = (output ?? '') + defaultStringRequestEnd;

    var templateSingleSuccess = Template(defaultTemplateRequestSuccess);
    output = (output ?? '') + templateSingleSuccess.render({"code": 200});
    output = (output ?? '') + defaultStringResponseResult;
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
