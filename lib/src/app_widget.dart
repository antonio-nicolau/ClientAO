import 'package:client_ao/src/modules/home/pages/home.page.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themModeState = ref.watch(themesProvider);

    return MaterialApp(
      title: 'ClientAO',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: themModeState,
      home: const HomePage(),
    );
  }
}
