import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:client_ao/src/modules/home/states/request_headers.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestHeaderField extends HookConsumerWidget {
  const RequestHeaderField(this.widgetKey, {super.key});

  final UniqueKey widgetKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerEditingController = useTextEditingController();
    final valueEditingController = useTextEditingController();

    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: headerEditingController,
              decoration: const InputDecoration(hintText: 'Header'),
              onChanged: (key) {
                HttpHeader? header = ref.watch(requestHeadersStateProvider)[widgetKey];
                header ??= HttpHeader();
                ref.read(requestHeadersStateProvider.notifier).state[widgetKey] = header.copyWith(key: key);
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: valueEditingController,
              decoration: const InputDecoration(hintText: 'Value'),
              onChanged: (value) {
                HttpHeader? header = ref.watch(requestHeadersStateProvider)[widgetKey];
                header ??= HttpHeader();
                ref.read(requestHeadersStateProvider.notifier).state[widgetKey] = header.copyWith(value: value);
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              ref.read(requestHeaderNotifierProvider.notifier).removeAt(widgetKey);
            },
            icon: const Icon(Icons.remove_circle),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
