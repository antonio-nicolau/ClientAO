import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:jinja/jinja.dart' as jj;

class DartCodeGen {
  String defaultUrlTemplate = """import 'package:http/http.dart' as http;
void main() async {
  var uri = Uri.parse('{{url}}');
""";

  String defaultParamsTemplate = """
  var queryParams = {{params}};
""";
  int kParamsPadding = 20;

  String kStringUrlParams = """
  var urlQueryParams = Map<String,String>.from(uri.queryParameters);
  urlQueryParams.addAll(queryParams);
  uri = uri.replace(queryParameters: urlQueryParams);
""";

  String kStringNoUrlParams = """
  uri = uri.replace(queryParameters: queryParams);
""";

  String kTemplateBody = """
  String body = r'''{{body}}''';
""";

  String kBodyImportDartConvert = """
import 'dart:convert';
""";

  String kBodyLength = """

  final contentLength = utf8.encode(body).length;
""";

  String kTemplateHeaders = """
  final headers = {{headers}};
""";
  int kHeadersPadding = 16;

  String kTemplateRequest = """
  final response = await http.{{method}}(uri""";

  String kStringRequestHeaders = """,
    headers: headers""";

  String kStringRequestBody = """,
    body: body""";
  String kStringRequestEnd = """);
""";

  String kTemplateSingleSuccess = """
  if (response.statusCode == {{code}}) {
""";

  String kTemplateMultiSuccess = """
  if ({{codes}}.contains(response.statusCode)) {\n""";

  String kStringResult = r"""
    
    // Your own logic to handle response
    print('Result: ${response.body}');
  }
  else{
    print('Error Status Code: ${response.statusCode}');
  }
}
""";

  String? getCode(RequestModel requestModel) {
    try {
      String result = "";
      bool hasHeaders = false;
      bool hasBody = false;

      String? url = requestModel.url;
      if (!(url?.contains("://") == true) && url?.isNotEmpty == true) {
        url = Protocol.https + url!;
      }
      var urlTemplate = jj.Template(defaultUrlTemplate);
      result += urlTemplate.render({"url": url});

      final paramsList = requestModel.urlParams;
      if (paramsList != null) {
        final params = listToMap(requestModel.urlParams);
        if (params?.isNotEmpty == true) {
          var templateParams = jj.Template(defaultParamsTemplate);
          var paramsString = const JsonEncoder.withIndent(' ').convert(params);
          paramsString = padMultilineString(paramsString, kParamsPadding);
          result += templateParams.render({"params": paramsString});
          Uri uri = Uri.parse(url!);
          if (uri.hasQuery) {
            result += kStringUrlParams;
          } else {
            result += kStringNoUrlParams;
          }
        }
      }

      var method = requestModel.method;
      var requestBody = requestModel.body;
      if (requestBody != null) {
        final contentLength = utf8.encode(requestBody).length;
        if (contentLength > 0) {
          hasBody = true;
          var templateBody = jj.Template(kTemplateBody);
          result += templateBody.render({"body": requestBody});
          result = kBodyImportDartConvert + result;
          result += kBodyLength;
        }
      }

      var headersList = requestModel.headers;
      if (headersList != null || hasBody) {
        var headers = listToMap(requestModel.headers);
        if (headers?.isNotEmpty == true || hasBody) {
          hasHeaders = true;
          headers?[HttpHeaders.contentLengthHeader] = r"$contentLength";

          var headersString = const JsonEncoder.withIndent(' ').convert(headers);
          headersString = padMultilineString(headersString, kHeadersPadding);
          final templateHeaders = jj.Template(kTemplateHeaders);
          result += templateHeaders.render({"headers": headersString});
        }
      }

      var templateRequest = jj.Template(kTemplateRequest);
      result += templateRequest.render({"method": method.name});

      if (hasHeaders) {
        result += kStringRequestHeaders;
      }

      if (hasBody) {
        result += kStringRequestBody;
      }

      result += kStringRequestEnd;

      var templateSingleSuccess = jj.Template(kTemplateSingleSuccess);
      result += templateSingleSuccess.render({"code": 200});
      result += kStringResult;

      return result;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
