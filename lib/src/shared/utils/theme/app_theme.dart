import 'package:client_ao/src/shared/utils/theme/app_theme.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Themes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    primaryColorDark: Colors.white,
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(),
      backgroundColor: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey.shade900,
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white70),
      titleMedium: TextStyle(color: Colors.white70),
    ),
    dialogTheme: DialogTheme(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.grey.shade900,
    ),
    popupMenuTheme: PopupMenuThemeData(color: Colors.grey.shade900),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.grey.shade600),
    ),
  );
}

final appColorsProvider = StateProvider<AppColors>((ref) {
  final themMode = ref.watch(themesProvider);
  return AppColors(themMode);
});

class AppColors extends StateNotifier<Color?> {
  AppColors(this._themeMode) : super(null);
  final ThemeMode? _themeMode;

  Color? selectedColor() {
    return _themeMode == ThemeMode.dark ? Colors.grey.shade800 : Colors.grey[350];
  }
}
