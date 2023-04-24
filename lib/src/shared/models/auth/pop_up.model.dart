
import 'package:equatable/equatable.dart';

class PopupMenuModel extends Equatable {
  final String label;
  final String displayName;
  final dynamic method;

  const PopupMenuModel({required this.label, required this.displayName, required this.method});

  @override
  List<Object?> get props => [label, displayName, method];
}
