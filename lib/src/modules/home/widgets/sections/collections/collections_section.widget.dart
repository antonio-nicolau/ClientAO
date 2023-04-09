import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/core/utils/layout.utils.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionsSection extends HookConsumerWidget {
  const CollectionsSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collections = ref.watch(collectionsNotifierProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
                onPressed: () {
                  final newId = ref.read(collectionsNotifierProvider.notifier).addRequest();
                  ref.read(activeIdProvider.notifier).update((state) => state?.copyWith(collection: newId));
                },
                child: const Text('New collection')),
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
                  child: _CollectionListItem(
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

class _CollectionListItem extends ConsumerWidget {
  const _CollectionListItem({
    super.key,
    required this.collectionId,
    required this.collection,
  });

  final CollectionModel collection;
  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);

    return ExpansionTile(
      key: Key(activeId?.requestId.toString() ?? ''),
      title: Text('${collection.name}'),
      initiallyExpanded: activeId?.collection == collectionId,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: collection.requestModel?.length,
            itemBuilder: (context, index) {
              final request = collection.requestModel?[index];
              return GestureDetector(
                onTap: () {
                  print("calic:$index");
                  ref.read(activeIdProvider.notifier).update(
                        (state) => state?.copyWith(requestId: index),
                      );
                },
                child: Container(
                  color: activeId?.requestId == index ? Colors.grey[350] : Colors.grey[100],
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        (request?.method.name)?.toUpperCase() ?? '',
                        style: TextStyle(
                          color: getRequestMethodColor(request?.method),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          collection.name ?? getRequestTitleFromUrl(request?.url),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
