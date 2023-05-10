import 'package:client_ao/src/shared/services/cache/environment_hive.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final environmentsProvider = Provider.autoDispose<List<String>>((ref) {
  return ref.read(environmentHiveServiceProvider).getAllEnvironments();
});

final getEnvironmentValuesByKeyProvider = Provider.family.autoDispose<Map<dynamic, dynamic>?, String>((ref, key) {
  return ref.read(environmentHiveServiceProvider).getEnvironmentValuesByKey(key);
});

final selectedEnvironmentProvider = StateProvider<String?>((ref) {
  return ref.read(environmentHiveServiceProvider).getSelectedEnvironment();
});
