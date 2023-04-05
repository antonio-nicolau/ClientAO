import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UrlParamField extends HookConsumerWidget {
  UrlParamField({super.key, required this.index, required this.row});

  HttpHeader row;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId(activeId);
    final urlParamsRows = ref.watch(collectionsNotifierProvider)[collectionIndex].requestModel?.headers;
    final keyController = useTextEditingController(text: row.key);
    final valueController = useTextEditingController(text: row.value);

    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: keyController,
              decoration: const InputDecoration(hintText: 'Key'),
              onChanged: (key) {
                row = row.copyWith(key: key);
                urlParamsRows?[index] = row;
                ref.read(collectionsNotifierProvider.notifier).updateUrlParams(
                      activeId,
                      urlParams: urlParamsRows,
                    );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: valueController,
              decoration: const InputDecoration(hintText: 'Value'),
              onChanged: (value) {
                row = row.copyWith(value: value);
                urlParamsRows?[index] = row;
                ref.read(collectionsNotifierProvider.notifier).updateUrlParams(
                      activeId,
                      urlParams: urlParamsRows,
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
