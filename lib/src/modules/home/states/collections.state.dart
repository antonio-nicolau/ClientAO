import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/services/collection.service.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/models/response.model.dart';
import 'package:client_ao/src/shared/services/hive_data.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// A provider to save the current collection and request selected by user
final activeIdProvider = StateProvider<ActiveId?>((ref) => ActiveId());

final responseStateProvider = StateProvider.family<AsyncValue<ResponseModel?>?, ActiveId?>((ref, activeId) {
  final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId();
  final collections = ref.watch(collectionsNotifierProvider);

  if (collections.isNotEmpty) {
    return AsyncData(collections[collectionIndex].responses?.get(activeId?.requestId ?? 0));
  }
  return null;
});

final collectionsNotifierProvider = StateNotifierProvider<CollectionsNotifier, List<CollectionModel>>((ref) {
  return CollectionsNotifier(ref);
});

class CollectionsNotifier extends StateNotifier<List<CollectionModel>> {
  CollectionsNotifier(this._ref) : super([]) {
    final loaded = loadFromCache();

    if (loaded) return;

    final id = newCollection();

    Future.microtask(() {
      _ref.read(activeIdProvider.notifier).update(
            (state) => state?.copyWith(collection: id, requestId: 0),
          );
    });
  }

  final Ref _ref;

  bool loadFromCache() {
    final collections = _ref.read(hiveDataServiceProvider).getCollections();

    state = collections ?? [];

    if (collections != null && collections.isNotEmpty == true) {
      Future.microtask(() {
        _ref.read(activeIdProvider.notifier).update(
              (state) => state?.copyWith(
                collection: collections.first.id,
                requestId: 0,
              ),
            );
      });
    }

    return true;
  }

  String addRequest(String? id) {
    CollectionModel collection = state.firstWhere((e) => e.id == id);

    final requests = collection.requests ?? [];
    final responses = collection.responses ?? [];

    collection = collection.copyWith(
      requests: [
        ...requests,
        const RequestModel(
          headers: [KeyValueRow()],
          urlParams: [KeyValueRow()],
        )
      ],
      responses: [...responses, const ResponseModel()],
    );

    state = [
      for (final e in state)
        if (e.id == collection.id) collection else e
    ];

    return collection.id;
  }

  Future<void> sendRequest() async {
    final activeId = _ref.read(activeIdProvider);
    final requestId = activeId?.requestId ?? 0;
    final index = indexOfId();
    final collection = getCollection();
    final request = collection?.requests?[requestId];
    final requestResponse = collection?.responses;

    updateRequestResponseState(const AsyncLoading());

    final response = await _ref.read(collectionServiceProvider).request(request!);

    requestResponse?[activeId?.requestId ?? 0] = response.value;

    state[index] = state[index].copyWith(responses: requestResponse);
    updateRequestResponseState(response);
  }

  void updateRequestResponseState(AsyncValue<ResponseModel?> newState) {
    final activeId = _ref.read(activeIdProvider);
    _ref.read(responseStateProvider(activeId).notifier).update((state) => newState);
  }

  CollectionModel? getCollection() => state.get(indexOfId());

  String newCollection() {
    final newCollection = CollectionModel(
      id: uuid.v4(),
      requests: const <RequestModel>[],
      responses: const <ResponseModel>[],
    );
    state = [newCollection, ...state];

    addRequest(newCollection.id);

    return newCollection.id;
  }

  int indexOfId() {
    final activeId = _ref.read(activeIdProvider);
    final index = state.indexWhere((e) => e.id == activeId?.collection);

    if (index != -1) return index;
    return 0;
  }

  void updateRequest({
    HttpVerb? method,
    String? url,
    List<KeyValueRow>? headers,
    String? name,
    String? body,
    List<KeyValueRow>? urlParams,
  }) {
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;
    final collection = getCollection();
    final requests = collection?.requests;

    requests?[requestId] = requests[requestId]?.copyWith(
      method: method,
      name: name,
      url: url,
      body: body,
      urlParams: urlParams,
      headers: headers,
    );

    final newCollection = collection?.copyWith(requests: requests);

    _addToCollection(newCollection);
  }

  void _addToCollection(CollectionModel? newCollection) {
    final index = indexOfId();

    if (newCollection != null) {
      state = [
        ...state.sublist(0, index),
        newCollection,
        ...state.sublist(index + 1),
      ];
    }
  }

  void removeAllHeaders() {
    updateRequest(headers: <KeyValueRow>[const KeyValueRow()]);
  }

  void removeHeader(int index) {
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;
    CollectionModel? collection = getCollection();
    final requests = collection?.requests;

    requests?[requestId]?.headers?.removeAt(index);

    collection = collection?.copyWith(requests: requests);

    _addToCollection(collection);
  }

  void removeAllUrlParams() {
    updateRequest(urlParams: <KeyValueRow>[const KeyValueRow()]);
  }

  void removeUrlParam(int index) {
    final requestId = _ref.read(activeIdProvider)?.requestId ?? 0;
    CollectionModel? collection = getCollection();
    final requests = collection?.requests;

    requests?[requestId]?.urlParams?.removeAt(index);

    collection = collection?.copyWith(requests: requests);

    _addToCollection(collection);
  }

  void removeRequest(int index) {
    CollectionModel? collection = getCollection();
    final requests = collection?.requests;

    requests?.removeAt(index);

    collection = collection?.copyWith(requests: requests);

    _addToCollection(collection);
  }

  void removeCollection(String id) {
    state = [
      for (final item in state)
        if (item.id != id) item
    ];
  }

  void renameCollection(String name) {
    final collection = getCollection();

    final newCollection = collection?.copyWith(name: name);

    _addToCollection(newCollection);
  }
}
