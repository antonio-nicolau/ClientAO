import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/services/storage.interface.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final envBox = Hive.box<String>('environments');
final selectedEnvBox = Hive.box<String>('selectedEnvironment');

final hiveServiceProvider = Provider<IStorage>((ref) {
  return HiveService(ref);
});

class HiveService implements IStorage {
  final Ref _ref;

  const HiveService(this._ref);

  @override
  Future<void> saveEnvironment({
    int? index,
    String envName = 'New Environment',
    Map<String, dynamic>? value,
  }) async {
    if (envName.isEmpty) return;

    if (envBox.isNotEmpty && index != null) {
      await envBox.putAt(index, envName);
      _ref.invalidate(environmentsProvider);
      return;
    }
    await envBox.add(envName);
  }

  @override
  Future<void> clearAll() async {
    await envBox.clear();
    _ref.invalidate(environmentsProvider);
  }

  @override
  Future<void> saveEnvironmentValue({
    required String key,
    required Map<dynamic, dynamic> value,
  }) async {
    final box = Hive.box<Map<dynamic, dynamic>>('environmentValues');

    if (box.containsKey(key)) {
      return box.putAtKey(key, value);
    }

    await box.put(key, value);
  }

  @override
  List<String> getAllEnvironments() {
    return envBox.values.toList();
  }

  @override
  Map<dynamic, dynamic>? getEnvironmentValuesByKey(String key) {
    final box = Hive.box<Map<dynamic, dynamic>>('environmentValues');
    return box.get(key);
  }

  @override
  Future<void> saveSelectedEnvironment(String value) async {
    selectedEnvBox.clear();
    await selectedEnvBox.add(value);
  }

  @override
  String? getSelectedEnvironment() {
    final values = selectedEnvBox.values;

    if (values.isNotEmpty) return values.first;

    return null;
  }

  @override
  Future<void> clearSelectedEnvironment() async {
    await selectedEnvBox.clear();
  }
}
