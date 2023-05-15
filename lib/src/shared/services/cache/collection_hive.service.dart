import 'dart:developer';
import 'package:client_ao/src/modules/settings/models/setting.model.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/models/response.model.dart';
import 'package:client_ao/src/shared/models/websocket_message.model.dart';
import 'package:client_ao/src/shared/models/websocket_request.model.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionsBox = Hive.box<CollectionModel>('collections');

final collectionHiveServiceProvider = Provider<ILocalDataStorage>((ref) {
  return const CollectionHiveService();
});

abstract class ILocalDataStorage {
  Future<void> saveCollection(CollectionModel? collection);
  List<CollectionModel>? getCollections();
  Future<void> deleteCollection(String key);
  Future<void> removeUnusedIds(List<CollectionModel> collections);
}

class CollectionHiveService implements ILocalDataStorage {
  const CollectionHiveService();

  @override
  List<CollectionModel>? getCollections() {
    return collectionsBox.values.toList();
  }

  @override
  Future<void> saveCollection(CollectionModel? collection) async {
    if (collection == null) return;

    if (collectionsBox.isNotEmpty && collectionsBox.containsKey(collection.id)) {
      await collectionsBox.putAtKey(collection.id, collection);
      return;
    }

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
  await Hive.openBox<bool>('darkMode');
  await Hive.openBox<Setting>('settings');
}

void registerAdapters() async {
  Hive.registerAdapter<HttpVerb>(HttpVerbAdapter());
  Hive.registerAdapter<KeyValueRow>(KeyValueRowAdapter());
  Hive.registerAdapter<RequestModel>(RequestModelAdapter());
  Hive.registerAdapter<ResponseModel>(ResponseModelAdapter());
  Hive.registerAdapter<CollectionModel>(CollectionModelAdapter());
  Hive.registerAdapter<Setting>(SettingAdapter());
  Hive.registerAdapter<WebSocketRequest>(WebSocketRequestAdapter());
  Hive.registerAdapter<WebSocketMessage>(WebSocketMessageAdapter());
  Hive.registerAdapter<SentFrom>(SentFromAdapter());
  Hive.registerAdapter<SocketConnectionStatus>(SocketConnectionStatusAdapter());
}

void clearAllCache() {}
