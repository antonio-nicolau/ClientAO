import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/core/models/key_value_row.model.dart';
import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/models/response.model.dart';
import 'package:client_ao/src/core/services/api_request.service.dart';
import 'package:client_ao/src/core/services/hive_data.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final activeIdProvider = StateProvider<ActiveId?>((ref) => ActiveId());

final collectionsNotifierProvider = StateNotifierProvider<CollectionsNotifier, List<CollectionModel>>((ref) {
  return CollectionsNotifier(ref);
});

final requestResponseStateProvider = StateProvider.family<AsyncValue<ResponseModel?>?, ActiveId?>((ref, activeId) {
  final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId();

  return ref.watch(collectionsNotifierProvider)[collectionIndex].responses?[activeId?.requestId ?? 0];
});

class CollectionsNotifier extends StateNotifier<List<CollectionModel>> {
  CollectionsNotifier(this._ref) : super([]) {
    final id = newCollection();

    Future.microtask(() {
      _ref.read(activeIdProvider.notifier).update(
            (state) => state?.copyWith(collection: id, requestId: 0),
          );
    });
  }

  final Ref _ref;

  String addRequest(String? id) {
    final old = state.firstWhere((e) => e.id == id);
    old.requests?.add(RequestModel(headers: [KeyValueRow()]));
    old.responses?.add(const AsyncValue.data(null));

    state = [
      for (final e in state)
        if (e.id == old.id) old else e
    ];

    return old.id;
  }

  Future<Response?> sendRequest() async {
    final activeId = _ref.read(activeIdProvider);
    final requestId = activeId?.requestId ?? 0;
    final index = indexOfId();
    final collection = getCollection();
    final request = collection.requests?[requestId];
    final requestResponse = collection.responses;

    _updateRequestResponseState(activeId, const AsyncLoading());

    if (request != null) {
      final response = await _ref.read(apiRequestProvider).request(request);
      requestResponse?[activeId?.requestId ?? 0] = AsyncData(ResponseModel.fromResponse(response: response));
      state[index] = state[index].copyWith(responses: requestResponse);
      _updateRequestResponseState(activeId, AsyncData(ResponseModel.fromResponse(response: response)));
      return response;
    }
    return null;
  }

  void _updateRequestResponseState(ActiveId? activeId, AsyncValue<ResponseModel> newState) {
    _ref.read(requestResponseStateProvider(activeId).notifier).update((state) => newState);
  }

  CollectionModel getCollection() {
    final idx = indexOfId();
    return state[idx];
  }

  String newCollection() {
    final newCollection = CollectionModel(
      id: uuid.v1(),
      requests: <RequestModel>[],
      responses: [AsyncData(null)],
    );
    state = [newCollection, ...state];

    _ref.read(hiveDataServiceProvider).saveCollection(newCollection.id, newCollection);

    addRequest(newCollection.id);

    return newCollection.id;
  }

  int indexOfId() {
    final activeId = _ref.read(activeIdProvider);
    final index = state.indexWhere((e) => e.id == activeId?.collection);

    if (index != -1) return index;
    return 0;
  }

  void updateRequestMethod(RequestMethod? method) {
    final activeId = _ref.read(activeIdProvider);
    final requestId = activeId?.requestId ?? 0;
    final collection = getCollection();
    final requests = collection.requests;

    requests?[requestId] = requests[requestId]?.copyWith(method: method);

    final newCollection = collection.copyWith(requests: requests);

    _addToCollection(newCollection);
  }

  void updateUrl(String? url) {
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;

    final collection = getCollection();

    final requests = collection.requests;

    requests?[requestId] = requests[requestId]?.copyWith(url: url);

    final newCollection = collection.copyWith(requests: requests);

    _addToCollection(newCollection);
  }

  void updateHeaders(List<KeyValueRow>? headers) {
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;
    final collection = getCollection();
    final requests = collection.requests;

    requests?[requestId] = requests[requestId]?.copyWith(headers: headers);

    final newCollection = collection.copyWith(requests: requests);

    _addToCollection(newCollection);
  }

  void updateUrlParams(urlParams) {
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;
    final collection = getCollection();
    final requests = collection.requests;

    requests?[requestId] = requests[requestId]?.copyWith(urlParams: urlParams);

    final newCollection = collection.copyWith(requests: requests);

    _addToCollection(newCollection);
  }

  List<CollectionModel> _addToCollection(CollectionModel newCollection) {
    final index = indexOfId();

    return state = [
      ...state.sublist(0, index),
      newCollection,
      ...state.sublist(index + 1),
    ];
  }

  void removeAllHeaders() {
    final activeId = _ref.read(activeIdProvider);
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;
    final index = activeId?.collection;
    final requests = getCollection().requests;

    requests?[requestId] = requests[requestId]?.copyWith(headers: [KeyValueRow()]);

    // state = [
    //   for (final e in state)
    //     e.copyWith(
    //       requestModel: e.requestModel?.copyWith(headers: [KeyValueRow()]),
    //     )
    // ];
  }

  void removeAllUrlParams() {
    // state = [
    //   for (final e in state)
    //     e.copyWith(
    //       requestModel: e.requestModel?.copyWith(urlParams: [KeyValueRow()]),
    //     )
    // ];
  }
}
