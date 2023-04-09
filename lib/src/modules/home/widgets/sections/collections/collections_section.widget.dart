import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collections_item.widget.dart';
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
          SizedBox(
            height: 34,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    final newId = ref.read(collectionsNotifierProvider.notifier).newCollection();
                    ref.read(activeIdProvider.notifier).update((state) => state?.copyWith(collection: newId, requestId: 0));
                  },
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.sort),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
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
                            requestId: index,
                          ),
                        );
                  },
                  child: CollectionListItem(
                    collectionId: collection.id,
                    collection: collection,
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
