import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponsePreviewTabs extends HookConsumerWidget {
  const ResponsePreviewTabs({super.key, required this.tabController});
  final TabController tabController;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final responseAsync = ref.watch(responseStateProvider(activeId));

    return responseAsync?.when(
          data: (data) {
            return TabBar(
              controller: tabController,
              tabs: [
                const Tab(text: 'Preview'),
                Tab(
                  text: 'Headers',
                  icon: Text(
                    "(${data?.headers?.length ?? 0})",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            );
          },
          error: (error, _) {
            return const Text('Error');
          },
          loading: () => const SizedBox.shrink(),
        ) ??
        const SizedBox.shrink();
  }
}
