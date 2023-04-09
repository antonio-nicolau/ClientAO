import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PopUpCollectionMenu extends HookConsumerWidget {
  const PopUpCollectionMenu(this.widgetRef, {super.key});

  final WidgetRef widgetRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final selectedMenu = useState<CollectionPopUpItem?>(null);

    return PopupMenuButton<CollectionPopUpItem>(
      initialValue: selectedMenu.value,
      itemBuilder: (BuildContext context) => CollectionPopUpItem.values.map((e) {
        return PopupMenuItem<CollectionPopUpItem>(
          value: e,
          child: Text(e.name),
          onTap: () {
            switch (e) {
              case CollectionPopUpItem.edit:
                // TODO: Handle this case.
                break;
              case CollectionPopUpItem.addRequest:
                widgetRef.read(collectionsNotifierProvider.notifier).addRequest(activeId?.collection);
                break;
              case CollectionPopUpItem.addFolder:
                // TODO: Handle this case.
                break;
            }
          },
        );
      }).toList(),
    );
  }
}
