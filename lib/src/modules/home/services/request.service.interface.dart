import 'package:client_ao/src/shared/models/request.params.dart';

abstract class IRequestService {
  Future<void> send(RequestParams params);
}
