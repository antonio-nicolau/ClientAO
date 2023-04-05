import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestHeaderField extends HookConsumerWidget {
  const RequestHeaderField(
    this.widgetKey, {
    super.key,
    required this.index,
    required this.row,
    this.keyFieldHintText,
    this.valueFieldHintText,
    this.onKeyFieldChanged,
    this.onValueFieldChanged,
  });

  final String? keyFieldHintText;
  final String? valueFieldHintText;
  final Function(String value)? onKeyFieldChanged;
  final Function(String value)? onValueFieldChanged;
  final HttpHeader row;
  final int index;

  final UniqueKey widgetKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId(activeId);
    final headerRows = ref.watch(collectionsNotifierProvider)[collectionIndex].requestModel?.headers;
    final headerController = useTextEditingController(text: row.key);
    final valueController = useTextEditingController(text: row.value);

    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: headerController,
              decoration: InputDecoration(hintText: keyFieldHintText ?? 'Header'),
              onChanged: (key) {
                if (onKeyFieldChanged != null) {
                  onKeyFieldChanged?.call(key);
                  return;
                }

                headerRows?[index] = row.copyWith(key: key);
                ref.read(collectionsNotifierProvider.notifier).updateHeaders(activeId, headers: headerRows);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: valueController,
              decoration: InputDecoration(hintText: valueFieldHintText ?? 'Value'),
              onChanged: (value) {
                if (onValueFieldChanged != null) {
                  onValueFieldChanged?.call(value);
                  return;
                }

                headerRows?[index] = row.copyWith(value: value);
                ref.read(collectionsNotifierProvider.notifier).updateHeaders(
                      activeId,
                      headers: headerRows,
                    );
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // ref.read(requestHeaderNotifierProvider.notifier).removeAt(widgetKey);
            },
            icon: const Icon(Icons.remove_circle),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
