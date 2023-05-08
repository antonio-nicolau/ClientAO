
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class PopupMenuModel extends Equatable {
  final String label;
  final String displayName;
  final dynamic method;
  final IconData? icon;
  final bool dividerAfterItem;
  final String? dividerLabel;

  const PopupMenuModel({
    required this.label,
    required this.displayName,
    this.icon,
    this.dividerAfterItem = false,
    this.dividerLabel,
    required this.method,
  });

  @override
  List<Object?> get props => [label, displayName, method, icon];
}
