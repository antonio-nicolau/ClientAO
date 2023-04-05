import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionsSection extends HookConsumerWidget {
  const CollectionsSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
                onPressed: () {
                  final newId = ref.read(collectionsNotifierProvider.notifier).add();
                  ref.read(activeIdProvider.notifier).update((state) => newId);
                },
                child: const Text('New collection')),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: collections.length,
              itemBuilder: (context, index) {
                if (collections.isEmpty == true) {
                  return const SizedBox.shrink();
                }

                final collection = collections[index];
                return GestureDetector(
                  onTap: () {
                    ref.read(activeIdProvider.notifier).update((state) => collection.id);
                  },
                  child: _CollectionListItem(collection: collection),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionListItem extends ConsumerWidget {
  const _CollectionListItem({super.key, required this.collection});

  final CollectionModel collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);

    return Container(
      color: activeId == collection.id ? Colors.black54 : Colors.grey[300],
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(
            (collection.requestModel?.method.name)?.toUpperCase() ?? '',
            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Text(
            collection.name ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
