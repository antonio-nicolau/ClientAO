import 'package:client_ao/src/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<Map<dynamic, dynamic>>('environmentValues');
  await Hive.openBox<String>('environments');
  await Hive.openBox<String>('selectedEnvironment');

  runApp(const ProviderScope(child: MyApp()));
}
