import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/services/api_request.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedMethodProvider = StateProvider<RequestMethod>((ref) {
  return RequestMethod.get;
});

class UrlCard extends HookConsumerWidget {
  const UrlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlController = useTextEditingController(text: 'https://jsonplaceholder.typicode.com/todos/1');

    void request() {
      final url = urlController.text.trim();
      final method = ref.read(selectedMethodProvider);

      final requestModel = RequestModel(
        url: url,
        body: 'body',
        method: method,
      );

      ref.read(apiRequestNotifierProvider.notifier).request(requestModel);
    }

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          const DropdownButtonRequestMethod(),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: urlController,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Enter API endpoint like api.foss42.com/country/codes",
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: request,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class DropdownButtonRequestMethod extends HookConsumerWidget {
  const DropdownButtonRequestMethod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    // final activeId = ref.watch(activeIdStateProvider);
    // final collection = ref.read(collectionStateNotifierProvider)!;
    // final idIdx = collection.indexWhere((m) => m.id == activeId);
    final method = ref.watch(selectedMethodProvider);
    return DropdownButton<RequestMethod>(
      focusColor: surfaceColor,
      value: method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      onChanged: (RequestMethod? value) {
        ref.read(selectedMethodProvider.notifier).state = value ?? RequestMethod.get;
      },
      items: RequestMethod.values.map<DropdownMenuItem<RequestMethod>>((RequestMethod value) {
        return DropdownMenuItem<RequestMethod>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value.name.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}