import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themesProvider = StateNotifierProvider<ThemesProvider, ThemeMode?>((ref) {
  return ThemesProvider(ref);
});

final darkModeBox = Hive.box<bool>('darkMode');

class ThemesProvider extends StateNotifier<ThemeMode?> {
  ThemesProvider(this._ref) : super(ThemeMode.dark) {
    getTheme();
  }

  final Ref _ref;

  void getTheme() {
    final isOn = darkModeBox.get('isOn') ?? false;
    state = isOn ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme(bool isOn) {
    darkModeBox.put('isOn', isOn);
    _ref.invalidate(themesProvider);
  }
}
