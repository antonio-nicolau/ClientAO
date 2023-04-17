import 'dart:developer';

import 'package:hive/hive.dart';

extension HiveBox on Box {
  Future<void> putAtKey(String key, dynamic value) async {
    final index = keys.toList().indexWhere((e) => e == key);

    if (index != -1) {
      log('key: $index -> $key');
      await putAt(index, value);
    } else {
      log('key not found: $key');
    }
  }
}
