import 'dart:developer';

import 'package:hive/hive.dart';

extension ListExtension<T> on Iterable<T> {
  T? get(int? index) {
    if (isEmpty || index == null || index >= length) return null;

    return toList()[index];
  }
}

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
