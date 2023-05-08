import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class PopupMenuModel extends Equatable {
  final String label;
  final String displayName;
  final dynamic method;
  final IconData? icon;
  final bool dividerAfterItem;
  final String? dividerLabel;
  final VoidCallback? callback;
  final Widget? widget;

  const PopupMenuModel({
    required this.label,
    this.displayName = '',
    this.icon,
    this.dividerAfterItem = false,
    this.dividerLabel,
    this.method,
    this.callback,
    this.widget,
  });

  @override
  List<Object?> get props => [label, displayName, method, icon];
}
