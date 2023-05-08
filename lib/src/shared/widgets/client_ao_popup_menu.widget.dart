import 'package:client_ao/src/shared/models/pop_up.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClientAoPopupMenu extends HookConsumerWidget {
  /// A custom PopupMenu, it supports a label, icon, method and divider
  const ClientAoPopupMenu({
    super.key,
    required this.items,
    this.callback,
    this.icon,
    this.color,
    this.initialValue,
  });

  final List<PopupMenuModel> items;
  final Function(PopupMenuModel)? callback;
  final Icon? icon;
  final dynamic initialValue;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenu = useState<PopupMenuModel?>(initialValue);

    return PopupMenuButton<PopupMenuModel>(
      icon: icon,
      initialValue: selectedMenu.value,
      color: color ?? Theme.of(context).primaryColorDark,
      itemBuilder: (BuildContext context) => items.map((e) {
        return PopupMenuItem<PopupMenuModel>(
          value: e,
          onTap: () {
            Future.delayed(Duration.zero, () {
              callback?.call(e);
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (e.icon != null) Icon(e.icon),
                  if (e.icon != null) const SizedBox(width: 16),
                  Text(e.label),
                ],
              ),
              if (e.dividerAfterItem)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Text(e.dividerLabel ?? ''),
                      Expanded(
                        child: Divider(color: Theme.of(context).colorScheme.surfaceVariant),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
