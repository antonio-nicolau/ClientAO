import 'dart:developer';

import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/core/models/key_value_row.model.dart';
import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/models/response.model.dart';
import 'package:client_ao/src/core/utils/client_ao_extensions.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionsBox = Hive.box<CollectionModel>('collections');

final hiveDataServiceProvider = Provider<ILocalDataStorage>((ref) {
  return HiveDataService(ref);
});

abstract class ILocalDataStorage {
  Future<void> saveCollection(CollectionModel? collection);
  List<CollectionModel>? getCollections();
  Future<void> deleteCollection(String key);
  Future<void> removeUnusedIds(List<CollectionModel> collections);
}

class HiveDataService implements ILocalDataStorage {
  final Ref _ref;

  const HiveDataService(this._ref);

  @override
  List<CollectionModel>? getCollections() {
    return collectionsBox.values.toList();
  }

  @override
  Future<void> saveCollection(CollectionModel? collection) async {
    if (collection == null) return;

    if (collectionsBox.isNotEmpty && collectionsBox.containsKey(collection.id)) {
      log('same collection: ${collection.id}');
      await collectionsBox.putAtKey(collection.id, collection);
      return;
    }
    log('old collection');
    await collectionsBox.put(collection.id, collection);
  }

  @override
  Future<void> deleteCollection(String key) async {
    await collectionsBox.delete(key);
  }

  @override
  Future<void> removeUnusedIds(List<CollectionModel> collections) async {
    final validIds = collections.map((e) => e.id).toList();

    for (var item in collectionsBox.values.toList()) {
      if (!validIds.contains(item.id)) {
        collectionsBox.delete(item.id);
        log('removed ${item.id} from cache');
      }
    }

    return;
  }
}

Future<void> openHiveBoxes() async {
  await Hive.openBox<Map<dynamic, dynamic>>('environmentValues');
  await Hive.openBox<String>('environments');
  await Hive.openBox<String>('selectedEnvironment');
  await Hive.openBox<CollectionModel>('collections');
}

void registerAdapters() async {
  Hive.registerAdapter(HttpVerbAdapter());
  Hive.registerAdapter(KeyValueRowAdapter());
  Hive.registerAdapter(RequestModelAdapter());
  Hive.registerAdapter(ResponseModelAdapter());
  Hive.registerAdapter(CollectionModelAdapter());
}
