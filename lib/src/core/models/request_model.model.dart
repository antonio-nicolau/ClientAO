import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/http_header.model.dart';

class RequestModel {
  final Uri uri;
  final String body;
  final RequestMethod method;
  final List<HttpHeader>? headers;

  RequestModel({
    required this.uri,
    required this.body,
    this.method = RequestMethod.get,
    this.headers,
  });
}
