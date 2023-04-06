import 'package:equatable/equatable.dart';

class KeyValueRow extends Equatable {
  final String? key;
  final String? value;

  KeyValueRow({this.key, this.value});

  KeyValueRow copyWith({String? key, String? value}) {
    return KeyValueRow(key: key ?? this.key, value: value ?? this.value);
  }

  @override
  List<Object?> get props => [key, value];
}
