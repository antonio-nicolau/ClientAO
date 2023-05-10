import 'package:client_ao/src/modules/settings/services/settings.service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themesProvider = StateNotifierProvider<ThemesProvider, ThemeMode?>((ref) {
  final isDarkMode = ref.watch(settingsProvider.select((value) => value?.darkMode));
  return ThemesProvider(isDarkMode ?? false);
});

final darkModeBox = Hive.box<bool>('darkMode');

class ThemesProvider extends StateNotifier<ThemeMode?> {
  ThemesProvider(this._isDarkMode) : super(ThemeMode.dark) {
    getTheme();
  }

  final bool _isDarkMode;

  void getTheme() {
    state = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
