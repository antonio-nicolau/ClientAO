import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/models/pop_up.model.dart';
import 'package:client_ao/src/shared/widgets/client_ao_popup_menu.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final requestBodyTypeProvider = StateProvider<PopupMenuModel?>((ref) {
  return bodyMenuOptions.last;
});

class BodyTab extends ConsumerWidget {
  /// widget responsible to display body tab `label with an icon`
  /// to show popup menu with supported body types
  const BodyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyType = ref.watch(requestBodyTypeProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: Text('${bodyType?.label}', maxLines: 1)),
        const SizedBox(width: 5),
        Expanded(
          child: ClientAoPopupMenu(
            items: bodyMenuOptions,
            initialValue: bodyType,
            icon: const Icon(Icons.arrow_drop_down),
            callback: (value) {
              ref.read(requestBodyTypeProvider.notifier).state = value;
            },
          ),
        ),
      ],
    );
  }
}
