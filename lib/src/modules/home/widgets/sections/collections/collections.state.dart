import 'dart:developer';

import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final activeIdProvider = StateProvider<String?>((ref) => null);

final collectionsNotifierProvider = StateNotifierProvider<CollectionsNotifier, List<CollectionModel>>((ref) {
  return CollectionsNotifier(ref);
});

class CollectionsNotifier extends StateNotifier<List<CollectionModel>> {
  CollectionsNotifier(this._ref) : super([]) {
    final newId = add();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _ref.read(activeIdProvider.notifier).update((state) => newId);
    });
  }

  final Ref _ref;

  String add({String? name = 'New Request'}) {
    final newCollection = CollectionModel(
      id: uuid.v1(),
      name: name,
      requestModel: RequestModel(headers: [HttpHeader()]),
    );
    state = [newCollection, ...state];

    return newCollection.id;
  }

  void addHeader({String? name}) {
    state = [
      ...state,
      CollectionModel(
        id: uuid.v1(),
        name: name,
        requestModel: RequestModel(),
      ),
    ];
  }

  CollectionModel getCollectionModel(String? id) {
    final idx = indexOfId(id);
    return state[idx];
  }

  int indexOfId(String? id) {
    final index = state.indexWhere((e) => e.id == id);

    if (index != -1) return index;
    return 0;
  }

  void update(String? id, {String? name, RequestModel? requestModel}) {
    final index = indexOfId(id);
    final newCollection = state[index].copyWith(
      name: name,
      requestModel: requestModel,
    );

    _addToCollection(index, newCollection);
  }

  void updateUrl(String? id, String? url) {
    final index = indexOfId(id);

    final newCollection = state[index].copyWith(
      requestModel: state[index].requestModel?.copyWith(url: url),
    );
    log('URL: ${newCollection.requestModel!.url}');
    _addToCollection(index, newCollection);
  }

  void updateHeaders(String? id, {List<HttpHeader>? headers}) {
    final collection = getCollectionModel(id);
    final index = indexOfId(id);

    final newCollection = state[index].copyWith(
      requestModel: collection.requestModel?.copyWith(headers: headers),
    );

    _addToCollection(index, newCollection);
  }

  void updateUrlParams(String? id, {List<HttpHeader>? urlParams}) {
    final collection = getCollectionModel(id);
    final index = indexOfId(id);

    final newCollection = state[index].copyWith(
      requestModel: collection.requestModel?.copyWith(urlParams: urlParams),
    );

    _addToCollection(index, newCollection);
  }

  List<CollectionModel> _addToCollection(int index, CollectionModel newCollection) {
    return state = [
      ...state.sublist(0, index),
      newCollection,
      ...state.sublist(index + 1),
    ];
  }

  void removeAllHeaders() {
    state = [
      for (final e in state)
        e.copyWith(
          requestModel: e.requestModel?.copyWith(headers: [HttpHeader()]),
        )
    ];
  }

  void removeAllUrlParams() {
    state = [
      for (final e in state)
        e.copyWith(
          requestModel: e.requestModel?.copyWith(urlParams: [HttpHeader()]),
        )
    ];
  }
}
