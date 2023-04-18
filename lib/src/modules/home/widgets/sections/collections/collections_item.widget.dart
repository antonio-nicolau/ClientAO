import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/core/utils/layout.utils.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collection_name_textfield.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collection_pop_up_menu.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionListItem extends HookConsumerWidget {
  const CollectionListItem({
    super.key,
    required this.collectionId,
    required this.collection,
  });

  final CollectionModel collection;
  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMenu = useState<bool>(false);
    final activeId = ref.watch(activeIdProvider);

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
                if (showMenu.value) PopUpCollectionMenu(ref, collection),
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
              return Container(
                color: activeId?.requestId == index && activeId?.collection == collectionId ? Colors.grey[350] : Colors.grey[100],
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    ref.read(activeIdProvider.notifier).update(
                          (state) => state?.copyWith(
                            collection: collectionId,
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
                      ],
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }
}
