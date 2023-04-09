import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/models/response.model.dart';
import 'package:client_ao/src/core/services/api_request.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final activeIdProvider = StateProvider<ActiveId?>((ref) => ActiveId());

final collectionsNotifierProvider = StateNotifierProvider<CollectionsNotifier, List<CollectionModel>>((ref) {
  return CollectionsNotifier(ref);
});

final requestResponseStateProvider = StateProvider.family<AsyncValue<ResponseModel?>?, ActiveId?>((ref, activeId) {
  final collectionIndex = ref.read(collectionsNotifierProvider.notifier).indexOfId();

  return ref.watch(collectionsNotifierProvider)[collectionIndex].response?[activeId?.requestId ?? 0];
  // .firstWhere((e) => e.id == requestId.toString(), orElse: () => CollectionModel(id: uuid.v1()))
  // .response?[requestId ?? 0];
});

class CollectionsNotifier extends StateNotifier<List<CollectionModel>> {
  CollectionsNotifier(this._ref) : super([]) {
    state = [newCollection()];
    final id = state.first.id;

    addRequest();

    Future.microtask(() {
      _ref.read(activeIdProvider.notifier).update(
            (state) => state?.copyWith(collection: id, requestId: 0),
          );
    });
  }

  final Ref _ref;

  String addRequest() {
    final old = getCollection();
    old.requestModel?.add(RequestModel(headers: [KeyValueRow()]));
    old.response?.add(const AsyncValue.data(null));

    // final newCollection = old.copyWith(requestModel: old.requestModel);

    // final newCollection = CollectionModel(
    //   id: uuid.v1(),
    //   requestModel: RequestModel(headers: [KeyValueRow()]),
    // );
    // state = [newCollection, ...state];

    // state = [
    //   ...state.sublist(0, index),
    //   old,
    //   ...state.sublist(index + 1),
    // ];

    state = [
      for (final e in state)
        if (e.id == old.id) old else e
    ];

    return old.id;
  }

  // String add({String? name}) {
  //   final newCollection = CollectionModel(
  //     id: uuid.v1(),
  //     name: name,
  //     requestModel: RequestModel(headers: [KeyValueRow()]),
  //   );
  //   state = [newCollection, ...state];

  //   return newCollection.id;
  // }

  Future<Response?> sendRequest() async {
    final activeId = _ref.read(activeIdProvider);
    final requestId = activeId?.requestId ?? 0;
    final index = indexOfId();
    final collection = getCollection();
    final request = collection.requestModel?[requestId];
    final requestResponse = collection.response;

    _updateRequestResponseState(activeId, const AsyncLoading());

    if (request != null) {
      final response = await _ref.read(apiRequestProvider).request(request);
      requestResponse?[activeId?.requestId ?? 0] = AsyncData(ResponseModel.fromResponse(response: response));
      state[index] = state[index].copyWith(response: requestResponse);
      _updateRequestResponseState(activeId, AsyncData(ResponseModel.fromResponse(response: response)));
      return response;
    }
    return null;
  }

  void _updateRequestResponseState(ActiveId? activeId, AsyncValue<ResponseModel> newState) {
    _ref.read(requestResponseStateProvider(activeId).notifier).update((state) => newState);
  }

  // void addHeader({String? name}) {
  //   final activeId = _ref.read(activeIdProvider);
  //   final requestId = activeId?.requestId ?? 0;

  //   final requests = getCollectionModel(activeId?.collection).requestModel;

  //   requests?[requestId] = requests[requestId].copyWith()

  //   state = [
  //     ...state,
  //     CollectionModel(
  //       id: uuid.v1(),
  //       name: name,
  //       requestModel: const RequestModel(),
  //     ),
  //   ];
  // }

  CollectionModel getCollection() {
    final idx = indexOfId();
    return state[idx];
  }

  CollectionModel newCollection() {
    return CollectionModel(
      id: uuid.v1(),
      requestModel: <RequestModel>[
        // RequestModel(
        //   headers: [KeyValueRow()],
        //   urlParams: [KeyValueRow()],
        // )
      ],
      response: [
        AsyncData(null),
      ],
    );
  }

  int indexOfId() {
    final activeId = _ref.read(activeIdProvider);
    final index = state.indexWhere((e) => e.id == activeId?.collection);

    if (index != -1) return index;
    return 0;
  }

  void update({String? name, RequestModel? requestModel}) {
    final activeId = _ref.read(activeIdProvider);
    final requestId = activeId?.requestId ?? 0;
    final collection = getCollection();
    final requests = collection.requestModel;

    requests?[requestId] = requestModel;

    final newCollection = collection.copyWith(
      name: name,
      requestModel: requests,
    );

    _addToCollection(newCollection);
  }

  void updateUrl(String? url) {
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;

    final collection = getCollection();

    final requests = collection.requestModel;

    requests?[requestId] = requests[requestId]?.copyWith(url: url);

    print(requests?.map((e) => e?.url));

    final newCollection = collection.copyWith(requestModel: requests);

    _addToCollection(newCollection);
  }

  void updateHeaders(List<KeyValueRow>? headers) {
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;
    final collection = getCollection();
    final requests = collection.requestModel;

    requests?[requestId] = requests[requestId]?.copyWith(headers: headers);

    final newCollection = collection.copyWith(requestModel: requests);

    _addToCollection(newCollection);
  }

  void updateUrlParams(urlParams) {
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;
    final collection = getCollection();
    final requests = collection.requestModel;

    requests?[requestId] = requests[requestId]?.copyWith(urlParams: urlParams);

    final newCollection = collection.copyWith(requestModel: requests);

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
    final requests = getCollection().requestModel;

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
