import 'dart:io';
import 'dart:convert';
import 'package:client_ao/src/shared/code_generator/dart/dart_templates.dart';
import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:jinja/jinja.dart';

class DartCodeGenerator {
  /// class responsible to generate Dart code, it uses [Jinja] for [Template] creation

  static String? getCode(RequestModel? requestModel) {
    if (requestModel == null) return null;
    try {
      String result = "";
      bool hasHeaders = false;
      bool hasBody = false;

      String? url = requestModel.url;
      if (!(url?.contains("://") == true) && url?.isNotEmpty == true) {
        url = Protocol.https + url!;
      }

      var urlTemplate = Template(defaultHttpImportAndUriTemplate);
      result += urlTemplate.render({"url": url});

      final params = listToMap(requestModel.urlParams);
      if (params != null && params.isNotEmpty) {
        var templateParams = Template(defaultParamsTemplate);
        var paramsString = jsonEncoder.convert(params);
        paramsString = addPaddingToMultilineString(paramsString, defaultParamsPadding);

        result += templateParams.render({"params": paramsString});
        Uri uri = Uri.parse(url!);
        if (uri.hasQuery) {
          result += defaultStringWithUrlParams;
        } else {
          result += defaultStringWithNoUrlParams;
        }
      }

      var method = requestModel.method;
      var requestBody = requestModel.body;
      if (requestBody != null && method != HttpVerb.get) {
        final contentLength = utf8.encode(requestBody).length;
        if (contentLength > 0) {
          hasBody = true;
          var templateBody = Template(defaultTemplateBody);
          result += templateBody.render({"body": requestBody});
          result = defaultDartConvertImport + result;
          result += defaultBodyLength;
        }
      }
      var headers = listToMap(requestModel.headers) ?? {};

      if (headers.isNotEmpty || hasBody) {
        if (headers.isNotEmpty == true || hasBody) {
          hasHeaders = true;
          headers[HttpHeaders.contentLengthHeader] = r"$contentLength";

          var headersString = jsonEncoder.convert(headers);
          headersString = addPaddingToMultilineString(headersString, defaultHeadersPadding);
          final templateHeaders = Template(defaultTemplateHeaders);
          result += templateHeaders.render({"headers": headersString});
        }
      }

      var templateRequest = Template(defaultTemplateRequest);
      result += templateRequest.render({"method": method.name});

      if (hasHeaders) {
        result += defaultStringRequestHeaders;
      }

      if (hasBody) {
        result += defaultStringRequestBody;
      }

      result += defaultStringRequestEnd;

      var templateSingleSuccess = Template(defaultTemplateRequestSuccess);
      result += templateSingleSuccess.render({"code": 200});
      result += defaultStringResponseResult;

      return result;
    } catch (e) {
      return null;
    }
  }
}
