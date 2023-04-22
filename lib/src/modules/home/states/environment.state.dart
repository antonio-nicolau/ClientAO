import 'package:client_ao/src/shared/services/hive.service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final environmentsProvider = Provider.autoDispose<List<String>>((ref) {
  return ref.read(hiveServiceProvider).getAllEnvironments();
});

final getEnvironmentValuesByKeyProvider = Provider.family.autoDispose<Map<dynamic, dynamic>?, String>((ref, key) {
  return ref.read(hiveServiceProvider).getEnvironmentValuesByKey(key);
});

final selectedEnvironmentProvider = StateProvider<String?>((ref) {
  return ref.read(hiveServiceProvider).getSelectedEnvironment();
});
