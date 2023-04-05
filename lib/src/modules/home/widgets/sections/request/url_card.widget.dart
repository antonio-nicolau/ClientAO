import 'dart:developer';

import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/services/api_request.service.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedMethodProvider = StateProvider<RequestMethod>((ref) {
  return RequestMethod.get;
});

final requestModelProvider = StateProvider.family<RequestModel, String>((ref, uid) {
  return RequestModel();
});

class UrlCard extends HookConsumerWidget {
  const UrlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId(activeId);
    final collection = ref.watch(collectionsNotifierProvider)[collectionIndex];
    final urlController = useTextEditingController(text: 'https://jsonplaceholder.typicode.com/comments?postId=1');

    void request() {
      final requestModel = collection.requestModel;

      if (requestModel != null) {
        ref.read(apiRequestNotifierProvider.notifier).request(requestModel);
      }
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
                hintText: "Enter API endpoint like clientao.ao/download/country",
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                ref.read(collectionsNotifierProvider.notifier).updateUrl(
                      collection.id,
                      value,
                    );
              },
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
    final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId(activeId);
    final collection = ref.watch(collectionsNotifierProvider)[collectionIndex];

    return DropdownButton<RequestMethod>(
      focusColor: Theme.of(context).colorScheme.surface,
      value: collection.requestModel?.method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      onChanged: (RequestMethod? value) {
        final requestMethod = collection.requestModel;
        ref.read(collectionsNotifierProvider.notifier).update(
              activeId,
              requestModel: requestMethod?.copyWith(method: value ?? RequestMethod.get),
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
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
