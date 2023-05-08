import 'package:client_ao/src/modules/home/states/environment.state.dart';
import 'package:client_ao/src/shared/services/storage.interface.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final envBox = Hive.box<String>('environments');
final selectedEnvBox = Hive.box<String>('selectedEnvironment');
final envValuesBox = Hive.box<Map<dynamic, dynamic>>('environmentValues');

final environmentHiveServiceProvider = Provider<IStorage>((ref) {
  return EnvironmentHiveService(ref);
});

class EnvironmentHiveService implements IStorage {
  final Ref _ref;

  const EnvironmentHiveService(this._ref);

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
    await selectedEnvBox.clear();
    await envValuesBox.clear();

    _ref.invalidate(environmentsProvider);
    _ref.invalidate(selectedEnvironmentProvider);
    _ref.invalidate(getEnvironmentValuesByKeyProvider);
  }

  @override
  Future<void> saveEnvironmentValue({
    required String key,
    required Map<dynamic, dynamic> value,
  }) async {
    if (envValuesBox.containsKey(key)) {
      return envValuesBox.putAtKey(key, value);
    }

    await envValuesBox.put(key, value);
  }

  @override
  List<String> getAllEnvironments() {
    return envBox.values.toList();
  }

  @override
  Map<dynamic, dynamic>? getEnvironmentValuesByKey(String key) {
    return envValuesBox.get(key);
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

  @override
  List<String> getEnvironmentsKey() {
    return envBox.keys.map((e) => '$e').toList();
  }

  @override
  Future<void> removeEnvironment(String key, int index) async {
    bool lastEnvironment = false;

    if (envBox.isEmpty) return;

    if (envBox.length == 1) {
      lastEnvironment = true;
    }

    await envBox.deleteAt(index);
    await envValuesBox.delete(key);

    _ref.invalidate(environmentsProvider);
    _ref.invalidate(getEnvironmentValuesByKeyProvider);

    if (lastEnvironment) _ref.invalidate(selectedEnvironmentProvider);
  }
}
