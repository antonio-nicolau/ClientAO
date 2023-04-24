import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/auth_layout_by_auth_method.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/auth_tab.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/body_tab/request_body.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/headers_tab/request_headers.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/url_params_tab/request_url_params.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/url_card/url_card.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_section.widget.dart';
import 'package:client_ao/src/shared/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestSection extends HookConsumerWidget {
  const RequestSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collectionsLength = ref.watch(collectionsNotifierProvider.select((value) => value.length));

    if (collectionsLength == 0) {
      return const EmptyCollectionsPage();
    }

    return SizedBox(
      key: Key(activeId.toString()),
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        children: [
          const UrlCard(),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                const Expanded(child: RequestEditor()),
                VerticalDivider(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                const Expanded(
                  child: ResponseSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RequestEditor extends HookConsumerWidget {
  const RequestEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 4);
    final activeId = ref.watch(activeIdProvider);

    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Params'),
            AuthTab(),
            Tab(text: 'Headers'),
            Tab(text: 'Body'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              const RequestUrlParams(),
              const AuthLayoutBasedOnMethod(),
              const RequestHeaders(),
              RequestBody(
                key: Key('value-${activeId?.requestId}'),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class EmptyCollectionsPage extends ConsumerWidget {
  const EmptyCollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emptyCollectionsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const Text(
            emptyCollectionsSubtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: () {
                ref.read(collectionsNotifierProvider.notifier).newCollection();
              },
              child: const Text(emptyCollectionsButtonText)),
        ],
      ),
    );
  }
}
