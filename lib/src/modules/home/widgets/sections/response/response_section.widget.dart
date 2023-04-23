import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/no_request_sent.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_status.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_headers.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_preview.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_preview_tabs.widget.dart';
import 'package:client_ao/src/shared/exceptions/client_ao_exception.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
import 'package:client_ao/src/shared/services/api_request.service.dart';
import 'package:client_ao/src/shared/widgets/client_ao_loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final displayResponsePreviewTabProvider = StateProvider<bool>((ref) {
  return false;
});

class ResponseSection extends HookConsumerWidget {
  const ResponseSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final tabController = useTabController(initialLength: 2);
    final responseAsync = ref.watch(responseStateProvider(activeId));
    final requestError = ref.watch(requestErrorProvider);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ResponseStatus(),
          ResponsePreviewTabs(tabController: tabController),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: responseAsync?.when(
                    data: (response) {
                      if (shouldDisplayResponseError(activeId, requestError)) {
                        return Center(child: Text(requestError?.message ?? ''));
                      } else if (response == null || response.body == null) {
                        return const NoRequestSent();
                      }

                      return ResponsePreview(response: response);
                    },
                    error: (error, _) => Text('$error'),
                    loading: () => const ClientAoLoading(),
                  ),
                ),
                const ResponseHeaders(),
              ],
            ),
          )
        ],
      ),
    );
  }

  bool shouldDisplayResponseError(ActiveId? activeId, ClientAoException? exception) {
    return exception != null &&
        exception.message.isNotEmpty &&
        exception.requestId == activeId?.requestId &&
        activeId?.collection == exception.collectionId;
  }
}
