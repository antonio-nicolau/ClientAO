import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/utils/layout.utils.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UrlCard extends HookConsumerWidget {
  const UrlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collection = ref.watch(collectionsNotifierProvider.notifier).getCollection();
    final url = collection.requestModel?[activeId?.requestId ?? 0]?.url;
    final urlController = useTextEditingController(text: url);
    final focusNode = useFocusNode();

    useEffect(
      () {
        urlController.text = url ?? '';
        return;
      },
      [activeId],
    );

    void request() {
      final requestModel = collection.requestModel;

      if (requestModel != null) {
        ref.read(collectionsNotifierProvider.notifier).sendRequest();
      }
      focusNode.requestFocus();
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
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: "Enter API endpoint",
              ),
              onChanged: (value) {
                ref.read(collectionsNotifierProvider.notifier).updateUrl(value);
              },
              onSubmitted: (value) => request.call(),
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
    final activeId = ref.watch(activeIdProvider);
    final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId();
    final collection = ref.watch(collectionsNotifierProvider)[collectionIndex];

    return DropdownButton<RequestMethod>(
      focusColor: Theme.of(context).colorScheme.surface,
      value: collection.requestModel?[activeId?.requestId ?? 0]?.method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      onChanged: (RequestMethod? value) {
        final requestMethod = collection.requestModel;
        ref.read(collectionsNotifierProvider.notifier).update(
              requestModel: requestMethod?[activeId?.requestId ?? 0]?.copyWith(method: value ?? RequestMethod.get),
            );
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
                    color: getRequestMethodColor(value),
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
