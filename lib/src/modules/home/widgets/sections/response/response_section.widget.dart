import 'package:client_ao/src/core/services/api_request.service.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/request_status.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_headers.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_pretty.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_preview_tabs.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponseSection extends HookConsumerWidget {
  const ResponseSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final tabController = useTabController(initialLength: 2);
    final requestResponse = ref.watch(requestResponseStateProvider(activeId));

    return Column(
      key: Key(activeId.toString()),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const RequestStatus(),
              ResponsePreviewTabs(tabController: tabController),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: requestResponse?.when(
                        data: (response) {
                          return ResponsePretty(response: response);
                        },
                        error: (error, _) {
                          return Text('Error: $error');
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    const ResponseHeaders(),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}


// final activeId = ref.watch(activeIdProvider);
//     final tabController = useTabController(initialLength: 2);
//     final collections = ref.watch(collectionsNotifierProvider);
//     final collectionIndex = ref.watch(collectionsNotifierProvider.notifier).indexOfId(activeId);
