import 'dart:developer';

import 'package:client_ao/src/core/services/hive_data.service.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/collections/collections_section.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/request_section.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_section.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:multi_split_view/multi_split_view.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(collectionsNotifierProvider.notifier).getCollection();

    // Listen for Collection model changes and update cache
    ref.listen(collectionsNotifierProvider, (previous, next) async {
      log('Updating collection cache: ${collection.id}');
      await ref.read(hiveDataServiceProvider).saveCollection(collection.id, collection);
    });

    return Scaffold(
      body: MultiSplitViewTheme(
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
            RequestSection(),
            ResponseSection(),
          ],
        ),
      ),
    );
  }
}
