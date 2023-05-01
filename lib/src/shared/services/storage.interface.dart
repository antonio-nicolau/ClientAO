abstract class IStorage {
  Future<void> saveEnvironment({
    int? index,
    String envName = 'New Environment',
    Map<String, dynamic>? value,
  });

  Future<void> saveEnvironmentValue({
    required String key,
    required Map<dynamic, dynamic> value,
  });

  Future<void> saveSelectedEnvironment(String value);

  String? getSelectedEnvironment();

  Future<void> clearSelectedEnvironment();

  Future<void> clearAll();

  List<String> getAllEnvironments();

  List<String> getEnvironmentsKey();

  Map<dynamic, dynamic>? getEnvironmentValuesByKey(String key);
}
