import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:http/http.dart';

abstract class IApiRequest {
  Future<Response> request(RequestModel request);
}
