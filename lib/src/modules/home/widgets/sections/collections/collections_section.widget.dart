import 'package:client_ao/src/modules/environments/environment_section.widget.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collections_names_list.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionsSection extends HookConsumerWidget {
  const CollectionsSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const EnvironmentSection(),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              height: 34,
              child: TextButton.icon(
                onPressed: () {
                  final newId = ref.read(collectionsNotifierProvider.notifier).newCollection();
                  ref.read(activeIdProvider.notifier).update((state) => state?.copyWith(collection: newId, requestId: 0));
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(4),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('New'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              key: Key('${collections.length}'),
              itemCount: collections.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (collections.isEmpty == true) {
                  return const SizedBox.shrink();
                }

                final collection = collections[index];

                return GestureDetector(
                  onTap: () {
                    ref.read(activeIdProvider.notifier).update(
                          (state) => state?.copyWith(
                            collection: collection.id,
                            requestId: 0,
                          ),
                        );
                  },
                  child: CollectionNamesList(
                    collectionId: collection.id,
                    collection: collection,
                    collectionIndex: index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
