import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/websocket/states/websocket.state.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_status.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_headers.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/response/response_preview_tabs.widget.dart';
import 'package:client_ao/src/shared/models/websocket_message.model.dart';
import 'package:client_ao/src/shared/utils/tables.utils.dart';
import 'package:client_ao/src/shared/widgets/text_fields/textField_with_environment_suggestion.widget.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebSocketResponseSection extends HookConsumerWidget {
  /// widget to build WebSocket response section, it contains a [Davi] table with local/remote messages
  const WebSocketResponseSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final activeId = ref.watch(activeIdProvider);
    ref.read(webSocketStreamProvider);
    final allMessages = ref.watch(allWebSocketMessagesProvider);

    final daviModel = useMemoized(
      () => createWebSocketResponseTable(context, allMessages),
      [allMessages],
    );

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ResponseSearch(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Davi<WebSocketMessage>(
                          key: Key('${activeId?.requestId}-${allMessages?.length}'),
                          daviModel,
                        ),
                      ),
                    ],
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
}

class ResponseSearch extends ConsumerWidget {
  const ResponseSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: TextFieldWithEnvironmentSuggestion(
              displaySuggestion: false,
              parentContext: context,
              hintText: 'Search',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ref.invalidate(allWebSocketMessagesProvider);
            },
            icon: const Icon(
              Icons.restore,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
