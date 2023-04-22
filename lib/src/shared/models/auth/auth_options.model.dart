import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:equatable/equatable.dart';

class AuthOptionModel extends Equatable {
  final String label;
  final String displayName;
  final AuthMethod method;

  const AuthOptionModel({required this.label, required this.displayName, required this.method});

  @override
  List<Object?> get props => [label, displayName, method];
}
