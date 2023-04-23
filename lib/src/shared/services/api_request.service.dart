import 'dart:io';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/constants/strings.dart';
import 'package:client_ao/src/shared/exceptions/client_ao_exception.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/repositories/api_request.repository.dart';
import 'package:client_ao/src/shared/repositories/api_request.repository.interface.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final requestErrorProvider = StateProvider<ClientAoException?>((ref) {
  return null;
});

final apiRequestServiceProvider = Provider<ApiRequestService>((ref) {
  final apiRequest = ref.read(apiRequestProvider);
  return  ApiRequestService(apiRequest,ref);
});

class ApiRequestService  {

  const ApiRequestService(this._apiRequest,this._ref);
  final IApiRequestRepository _apiRequest;
  final Ref _ref;

  Future<(http.Response,Duration)?> request(RequestModel request) async {
      final activeId = _ref.read(activeIdProvider);
      _ref.read(requestErrorProvider.notifier).update((state) => null);
    try {
      final response = await _apiRequest.request(request);
      return (response.$0,response.$1);
    } on SocketException catch(_){
      _ref.read(requestErrorProvider.notifier).state= ClientAoException(message: errorCouldNotSolveHost,requestId: activeId?.requestId,collectionId: activeId?.collection,);
    } catch (e) {
      // TODO: Improve error handling
      _ref.read(requestErrorProvider.notifier).state= ClientAoException(message: e.toString(),requestId: activeId?.requestId,collectionId: activeId?.collection,);
    }

    return null;
  }
}

