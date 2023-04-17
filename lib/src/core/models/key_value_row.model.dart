import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'key_value_row.model.g.dart';

@HiveType(typeId: 5)
class KeyValueRow extends Equatable {
  @HiveField(0)
  final String? key;

  @HiveField(1)
  final String? value;

  KeyValueRow({this.key, this.value});

  KeyValueRow copyWith({String? key, String? value}) {
    return KeyValueRow(key: key ?? this.key, value: value ?? this.value);
  }

  @override
  List<Object?> get props => [key, value];
}
