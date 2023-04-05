import 'package:equatable/equatable.dart';

class HttpHeader extends Equatable {
  final String? key;
  final String? value;

  HttpHeader({this.key, this.value});

  HttpHeader copyWith({String? key, String? value}) {
    return HttpHeader(key: key ?? this.key, value: value ?? this.value);
  }

  @override
  List<Object?> get props => [key, value];
}
