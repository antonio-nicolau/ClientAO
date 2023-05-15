import 'package:client_ao/src/shared/models/base_request.interface.dart';
import 'package:client_ao/src/shared/models/base_response.interface.dart';
import 'package:client_ao/src/shared/models/response.model.dart';
import 'package:client_ao/src/shared/services/api_request.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionServiceProvider = Provider<CollectionService>((ref) {
  return CollectionService(ref.read(apiRequestServiceProvider));
});

class CollectionService {
  final ApiRequestService _apiRequestService;

  const CollectionService(this._apiRequestService);

  Future<AsyncValue<BaseResponseModel?>> request(BaseRequestModel request) async {
    final (response, duration) = await _apiRequestService.request(request);

    if (response != null) {
      return AsyncData(ResponseModel.fromResponse(
        response: response,
        requestDuration: duration,
      ));
    }

    return const AsyncData(null);
  }
}
