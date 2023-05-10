import 'package:client_ao/src/app_widget.dart';
import 'package:client_ao/src/shared/services/cache/collection_hive.service.dart';
import 'package:client_ao/src/shared/utils/windows.utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupWindow();
  await Hive.initFlutter();
  registerAdapters();
  await openHiveBoxes();

  runApp(const ProviderScope(child: MyApp()));
}
