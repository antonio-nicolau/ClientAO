import 'package:client_ao/src/shared/models/base_request.interface.dart';
import 'package:http/http.dart';

abstract class IApiRequestRepository {
  Future<(Response, Duration)> request(BaseRequestModel request);
}
