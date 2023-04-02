import 'package:client_ao/src/core/services/api_request.service.dart';
import 'package:client_ao/src/modules/home/widgets/response_preview_tabs.widget.dart';
import 'package:client_ao/src/modules/home/widgets/request_status.widget.dart';
import 'package:client_ao/src/modules/home/widgets/response_headers.widget.dart';
import 'package:client_ao/src/modules/home/widgets/response_pretty.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResponseSection extends HookConsumerWidget {
  const ResponseSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final requestResponse = ref.watch(apiRequestNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
                      child: requestResponse.when(
                        data: (response) {
                          return ResponsePretty(response: response);
                        },
                        error: (error, _) {
                          return const Text('Error');
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
