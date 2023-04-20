import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/utils/layout.utils.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collection_name_textfield.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionListViewItem extends HookConsumerWidget {
  const CollectionListViewItem({
    super.key,
    required this.index,
    required this.request,
    required this.collection,
  });

  final RequestModel? request;
  final CollectionModel collection;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final showMenu = useState<bool>(false);
    final changeBackgroundOnHover = useState<bool>(false);

    return MouseRegion(
      onHover: (event) {
        showMenu.value = true;
        changeBackgroundOnHover.value = true;
      },
      onExit: (event) {
        showMenu.value = false;
        changeBackgroundOnHover.value = false;
      },
      child: Container(
        color: changeBackgroundOnHover.value
            ? Colors.grey[350]
            : activeId?.requestId == index && activeId?.collection == collection.id
                ? Colors.grey[350]
                : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: GestureDetector(
          onTap: () {
            ref.read(activeIdProvider.notifier).update(
                  (state) => state?.copyWith(
                    collection: collection.id,
                    requestId: index,
                  ),
                );
          },
          child: SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: CollectionNameTextField(
                    request?.name ?? getRequestTitleFromUrl(request?.url),
                  ),
                ),
                if (showMenu.value)
                  _PopUpRequestNameItemMenu(
                    widgetRef: ref,
                    collectionId: collection.id,
                    index: index,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PopUpRequestNameItemMenu extends HookConsumerWidget {
  const _PopUpRequestNameItemMenu({
    super.key,
    required this.widgetRef,
    required this.collectionId,
    required this.index,
  });

  final WidgetRef widgetRef;
  final String collectionId;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenu = useState<RequestPopUpItem?>(null);

    return PopupMenuButton<RequestPopUpItem>(
      initialValue: selectedMenu.value,
      icon: const Icon(Icons.arrow_drop_down),
      itemBuilder: (BuildContext context) => RequestPopUpItem.values.map((e) {
        return PopupMenuItem<RequestPopUpItem>(
          value: e,
          child: Text(e.name),
          onTap: () {
            switch (e) {
              case RequestPopUpItem.delete:
                widgetRef.read(activeIdProvider.notifier).update((state) => state?.copyWith(collection: collectionId));

                final length = widgetRef.read(collectionsNotifierProvider.notifier).getCollection().requests?.length;

                if (index >= (length ?? 0)) {
                  widgetRef.read(activeIdProvider.notifier).update((state) => state?.copyWith(requestId: index - 1));
                }

                widgetRef.read(collectionsNotifierProvider.notifier).removeRequest(index);

                break;
            }
          },
        );
      }).toList(),
    );
  }
}
