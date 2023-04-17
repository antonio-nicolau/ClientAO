import 'package:client_ao/src/core/models/key_value_row.model.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class KeyTextField extends HookConsumerWidget {
  const KeyTextField({
    super.key,
    required this.index,
    this.keyFieldHintText,
    this.onKeyFieldChanged,
    required this.row,
  });

  final int index;
  final String? keyFieldHintText;
  final Function(List<KeyValueRow>?)? onKeyFieldChanged;
  final KeyValueRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId();
    final rows = ref.watch(collectionsNotifierProvider)[collectionIndex].requests?[activeId?.requestId ?? 0]?.headers;
    final headerController = useTextEditingController(text: row.key);

    return TextField(
      controller: headerController,
      decoration: InputDecoration(hintText: keyFieldHintText ?? 'key'),
      onChanged: (key) {
        rows?[index] = row.copyWith(key: key);

        if (onKeyFieldChanged != null) {
          onKeyFieldChanged?.call(rows);
          return;
        }

        ref.read(collectionsNotifierProvider.notifier).updateHeaders(rows);
      },
    );
  }
}
