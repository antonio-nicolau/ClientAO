import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponsePreviewTabs extends HookConsumerWidget {
  const ResponsePreviewTabs({super.key, required this.tabController});
  final TabController tabController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabBar(
      controller: tabController,
      tabs: const [
        Tab(text: 'Preview'),
        Tab(text: 'Headers'),
      ],
    );
  }
}
