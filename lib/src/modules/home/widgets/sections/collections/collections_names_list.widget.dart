import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collection_names_item.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collection_pop_up_menu.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionNamesList extends HookConsumerWidget {
  const CollectionNamesList({
    super.key,
    required this.collectionId,
    required this.collection,
    required this.collectionIndex,
  });

  final CollectionModel collection;
  final String collectionId;
  final int collectionIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMenu = useState<bool>(false);

    return Column(
      children: [
        MouseRegion(
          onHover: (event) {
            showMenu.value = true;
          },
          onExit: (event) {
            showMenu.value = false;
          },
          child: SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${collection.name}'),
                if (showMenu.value)
                  PopUpCollectionMenu(
                    widgetRef: ref,
                    collection: collection,
                    index: collectionIndex,
                  ),
              ],
            ),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: collection.requests?.length,
            padding: const EdgeInsets.only(left: 16, top: 8),
            itemBuilder: (context, index) {
              final request = collection.requests?[index];
              return CollectionListViewItem(
                index: index,
                request: request,
                collection: collection,
              );
            }),
      ],
    );
  }
}
