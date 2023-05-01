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

    if (index != -1 && index < length) {
      log('key: $index -> $key');
      await putAt(index, value);
    } else {
      log('key not found: $key');
    }
  }
}

extension StringExtensions on String {
  (String,int) getStringFromEnd(int end) {
    int start = 0;
    int blankSpaceIndex = 0;

if(end > length)return (this,blankSpaceIndex);

    for (int i = end - 1; i >= 0; i--) {
      if (this[i] == ' ') {
        blankSpaceIndex++;
        
        if(start == 0){
          start = i;
        }
      }
    }
  
    if(start>=0 && (end >= 0 && end <= length)){
      final value = substring(start, end);
      return (value,blankSpaceIndex);
    }

    return (this, blankSpaceIndex);
  }

}
