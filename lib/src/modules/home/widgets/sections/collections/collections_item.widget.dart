import 'package:client_ao/src/core/models/collection.model.dart';
import 'package:client_ao/src/core/utils/layout.utils.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
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

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        dense: true,
        horizontalTitleGap: 0,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        child: ExpansionTile(
          key: Key('${activeId?.collection}:${activeId?.requestId}'),
          title: MouseRegion(
            onHover: (event) {
              showMenu.value = true;
            },
            onExit: (event) {
              showMenu.value = false;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${collection.name}'),
                if (showMenu.value) PopUpCollectionMenu(ref),
              ],
            ),
          ),
          leading: null,
          tilePadding: EdgeInsets.zero,
          initiallyExpanded: true,
          trailing: const SizedBox.shrink(),
          childrenPadding: const EdgeInsets.only(left: 16, top: 8),
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: collection.requestModel?.length,
                itemBuilder: (context, index) {
                  final request = collection.requestModel?[index];
                  return Container(
                    color: activeId?.requestId == index && activeId?.collection == collectionId ? Colors.grey[350] : Colors.grey[100],
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        ref.read(activeIdProvider.notifier).update(
                              (state) => state?.copyWith(
                                collection: collectionId,
                                requestId: index,
                              ),
                            );
                      },
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
                              request?.name ?? getRequestTitleFromUrl(request?.url),
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
        ),
      ),
    );
  }
}
