import 'package:client_ao/src/modules/settings/models/setting.model.dart';
import 'package:client_ao/src/shared/constants/hive_box.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final settingsProvider = StateNotifierProvider<SettingsService, Setting?>((ref) {
  return SettingsService();
});

class SettingsService extends StateNotifier<Setting?> {
  SettingsService() : super(null) {
    getSettingsFromCache();
  }

  void getSettingsFromCache() {
    state = settingsBox.get('settings') ?? const Setting();
  }

  void save() async {
    await settingsBox.put('settings', state ?? const Setting());
    getSettingsFromCache();
  }

  void update({
    int? requestTimeout,
    String? httpScheme,
    bool? darkMode,
  }) {
    state = state?.copyWith(
      requestTimeout: requestTimeout,
      httpScheme: httpScheme,
      darkMode: darkMode,
    );

    save();
  }
}
