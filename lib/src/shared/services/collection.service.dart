import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/models/response.model.dart';
import 'package:client_ao/src/shared/services/api_request.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionServiceProvider = Provider<CollectionService>((ref) {
  return CollectionService(ref.read(apiRequestServiceProvider));
});

class CollectionService {
  final ApiRequestService _apiRequestService;

  const CollectionService(this._apiRequestService);

  Future<AsyncValue<ResponseModel?>> request(RequestModel request) async {
    final response = await _apiRequestService.request(request);

    if (response != null) {
      return AsyncData(ResponseModel.fromResponse(
        response: response.$0,
        requestDuration: response.$1,
      ));
    }

    return const AsyncData(null);
  }
}
