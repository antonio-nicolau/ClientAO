import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:client_ao/src/shared/utils/layout.utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DropdownButtonRequestMethod extends HookConsumerWidget {
  const DropdownButtonRequestMethod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId();
    final collection = ref.watch(collectionsNotifierProvider).get(collectionIndex);

    return DropdownButton<HttpVerb>(
      focusColor: Theme.of(context).colorScheme.surface,
      value: collection?.requests?.get(activeId?.requestId)?.method,
      icon: const Icon(Icons.arrow_drop_down),
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
