String defaultHttpImportAndUriTemplate = """import 'package:http/http.dart' as http;

Future<void> main() async {

  var uri = Uri.parse('{{url}}');
  
""";

String defaultParamsTemplate = """

  final queryParams = {{params}};
""";

String defaultStringWithUrlParams = """


  var urlQueryParams = Map<String,String>.from(uri.queryParameters);

  urlQueryParams.addAll(queryParams);

  uri = uri.replace(queryParameters: urlQueryParams);
""";

String defaultStringWithNoUrlParams = """


  uri = uri.replace(queryParameters: queryParams);


""";

String defaultTemplateBody = """
  String body = r'''{{body}}''';
""";

String defaultDartConvertImport = """
import 'dart:convert';
""";

String defaultBodyLength = """


  final contentLength = utf8.encode(body).length;

""";

String defaultTemplateHeaders = """
  final headers = {{headers}};
""";
int defaultHeadersPadding = 16;

String defaultTemplateRequest = """


  final response = await http.{{method}}(uri""";

String defaultStringRequestHeaders = """,
    headers: headers""";

String defaultStringRequestBody = """,
    body: body""";

String defaultStringRequestEnd = """);
""";

String defaultTemplateRequestSuccess = """


  if (response.statusCode == {{code}}) {
""";

String defaultStringResponseResult = r"""
    
    // your your own logic to handle response
    print('Response: ${response.body}');
  }
  else{
    print('Error Status Code: ${response.statusCode}');
  }
}
""";
