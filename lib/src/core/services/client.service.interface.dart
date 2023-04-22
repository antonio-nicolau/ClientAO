import 'package:client_ao/src/core/models/request.model.dart';
import 'package:http/http.dart';

abstract class IApiRequest {
  Future<(Response,Duration)> request(RequestModel request);
}
