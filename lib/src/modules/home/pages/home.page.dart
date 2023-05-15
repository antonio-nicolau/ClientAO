import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collections_section.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/request_section.widget.dart';
import 'package:client_ao/src/modules/home/widgets/websocket/request/websocket_request_section.widget.dart';
import 'package:client_ao/src/modules/settings/pages/settings.page.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
import 'package:client_ao/src/shared/models/request.model.dart';
import 'package:client_ao/src/shared/models/websocket_request.model.dart';
import 'package:client_ao/src/shared/services/cache/collection_hive.service.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:multi_split_view/multi_split_view.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for Collection model changes and update cache
    ref.listen<List<CollectionModel>>(collectionsNotifierProvider, (previous, next) async {
      final index = ref.read(collectionsNotifierProvider.notifier).indexOfId();
      final collections = ref.read(collectionsNotifierProvider);
      final collection = collections.get(index);

      await ref.read(collectionHiveServiceProvider).saveCollection(collection);
      await ref.read(collectionHiveServiceProvider).removeUnusedIds(collections);
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MultiSplitViewTheme(
              data: MultiSplitViewThemeData(
                dividerThickness: 1,
                dividerPainter: DividerPainters.background(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  highlightedColor: Theme.of(context).colorScheme.outline,
                  animationEnabled: false,
                ),
              ),
              child: MultiSplitView(
                initialAreas: [
                  Area(size: MediaQuery.of(context).size.width * 0.25),
                ],
                children: const [
                  CollectionsSection(),
                  RequestSectionByRequestType(),
                ],
              ),
            ),
          ),
          const HomeFooter()
        ],
      ),
    );
  }
}

class HomeFooter extends ConsumerWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 24,
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          );
        },
        icon: const Icon(Icons.settings, size: 16),
        label: const Text('Settings'),
      ),
    );
  }
}

class RequestSectionByRequestType extends ConsumerWidget {
  const RequestSectionByRequestType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final request = ref.watch(collectionsNotifierProvider.notifier).getCollection()?.requests?.get(activeId?.requestId);

    if (request is RequestModel) {
      return const RequestSection();
    } else if (request is WebSocketRequest) {
      return const WebsocketRequestSection();
    }
    return const EmptyCollectionsPage();
  }
}
