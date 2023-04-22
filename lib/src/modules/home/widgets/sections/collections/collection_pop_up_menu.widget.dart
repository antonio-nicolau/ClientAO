import 'dart:developer';

import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PopUpCollectionMenu extends HookConsumerWidget {
  const PopUpCollectionMenu({
    super.key,
    required this.widgetRef,
    required this.index,
    required this.collection,
  });

  final WidgetRef widgetRef;
  final CollectionModel collection;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenu = useState<CollectionPopUpItem?>(null);

    return PopupMenuButton<CollectionPopUpItem>(
      initialValue: selectedMenu.value,
      itemBuilder: (BuildContext context) => CollectionPopUpItem.values.map((e) {
        return PopupMenuItem<CollectionPopUpItem>(
          value: e,
          child: Text(e.name),
          onTap: () {
            widgetRef.read(activeIdProvider.notifier).update((state) => state?.copyWith(collection: collection.id));
            switch (e) {
              case CollectionPopUpItem.addRequest:
                widgetRef.read(collectionsNotifierProvider.notifier).addRequest(collection.id);
                break;
              case CollectionPopUpItem.delete:
                widgetRef.read(collectionsNotifierProvider.notifier).removeCollection(collection.id);
                break;
            }
          },
        );
      }).toList(),
    );
  }
}
