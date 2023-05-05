import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/constants/default_values.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/auth/pop_up.model.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
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
    final selectedMenu = useState<PopupMenuModel?>(null);

    return PopupMenuButton<PopupMenuModel>(
      initialValue: selectedMenu.value,
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (BuildContext context) => collectionMenuOptions.map((e) {
        return PopupMenuItem<PopupMenuModel>(
          value: e,
          child: Text(e.displayName),
          onTap: () {
            widgetRef.read(activeIdProvider.notifier).update((state) => state?.copyWith(collection: collection.id));
            switch (e.method) {
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
