import 'package:client_ao/src/core/constants/enums.dart';

class RequestModel {
  final String url;
  final String body;
  final RequestMethod method;
  final Map<String, dynamic>? headers;

  RequestModel({
    required this.url,
    required this.body,
    this.method = RequestMethod.get,
    this.headers,
  });
}
