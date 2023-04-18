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
    final url = collection.requests?[activeId?.requestId ?? 0]?.url;
    final urlController = useTextEditingController(text: url);
    final focusNode = useFocusNode();

    useEffect(
      () {
        urlController.text = url ?? '';
        return;
      },
      [activeId],
    );

    void sendRequest() {
      final request = collection.requests;

      if (request != null) {
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
                ref.read(collectionsNotifierProvider.notifier).updateRequest(url: value);
              },
              onSubmitted: (value) => sendRequest.call(),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: sendRequest,
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

    return DropdownButton<HttpVerb>(
      focusColor: Theme.of(context).colorScheme.surface,
      value: collection.requests?[activeId?.requestId ?? 0]?.method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      onChanged: (HttpVerb? value) {
        ref.read(collectionsNotifierProvider.notifier).updateRequest(method: value);
      },
      items: HttpVerb.values.map<DropdownMenuItem<HttpVerb>>((HttpVerb value) {
        return DropdownMenuItem<HttpVerb>(
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
