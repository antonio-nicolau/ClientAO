import 'dart:async';

import 'package:client_ao/src/modules/home/services/request.service.interface.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/models/base_request.interface.dart';
import 'package:client_ao/src/shared/models/base_response.interface.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
import 'package:client_ao/src/shared/models/request.params.dart';
import 'package:client_ao/src/shared/models/websocket_message.model.dart';
import 'package:client_ao/src/shared/services/collection.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final httpRequestServiceProvider = Provider<IRequestService>((ref) {
  return HttpRequestService(ref);
});

class HttpRequestService implements IRequestService {
  final Ref _ref;

  const HttpRequestService(this._ref);

  @override
  Future<void> send(RequestParams params) async {
    final activeId = _ref.read(activeIdProvider);
    final index = _ref.read(collectionsNotifierProvider.notifier).indexOfId();
    final collection = _ref.read(collectionsNotifierProvider.notifier).getCollection();

    if (params.sendAfterDelay != null) {
      await Future.delayed(params.sendAfterDelay ?? Duration.zero);
    }

    Timer.periodic(params.requestInterval ?? Duration.zero, (timer) {
      processRequest(
        request: params.request!,
        collection: collection,
        activeId: activeId,
        index: index,
      );
      if (_ref.read(cancelRepeatRequestProvider)) {
        timer.cancel();
      }
    });
    return;
  }

  Future<void> processRequest({
    required BaseRequestModel request,
    CollectionModel? collection,
    ActiveId? activeId,
    required int index,
  }) async {
    var state = _ref.read(collectionsNotifierProvider);
    final requestResponse = collection?.responses;

    updateRequestResponseState(_ref, const AsyncLoading(), activeId?.requestId);

    final response = await _ref.read(collectionServiceProvider).request(request);

    if (response.value == null) return;

    requestResponse?[activeId?.requestId ?? 0] = [response.value!];
    state[index] = state[index].copyWith(responses: requestResponse);
    updateRequestResponseState(_ref, AsyncValue.data([response.value!]), activeId?.requestId);
  }
}

void updateRequestResponseState(
  Ref ref,
  AsyncValue<List<BaseResponseModel>?> newState,
  int? requestId,
) {
  final activeId = ref.read(activeIdProvider);

  if (activeId?.requestId != requestId && !ref.read(cancelRepeatRequestProvider)) {
    ref.read(cancelRepeatRequestProvider.notifier).state = true;
    return;
  }

  ref.read(responseStateProvider(activeId).notifier).state = newState;
  ref.read(collectionsNotifierProvider.notifier).updateResponse(newState.value ?? <WebSocketMessage>[]);
}
