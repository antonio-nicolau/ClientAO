import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/websocket/states/websocket.state.dart';
import 'package:client_ao/src/shared/models/websocket_message.model.dart';
import 'package:client_ao/src/shared/utils/tables.utils.dart';
import 'package:client_ao/src/shared/widgets/client_ao_loading.widget.dart';
import 'package:client_ao/src/shared/widgets/text_fields/textField_with_environment_suggestion.widget.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebSocketResponseSection extends HookConsumerWidget {
  /// widget to build WebSocket response section, it contains a [Davi] table with local/remote messages
  const WebSocketResponseSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    ref.read(webSocketStreamProvider);
    final responseAsync = ref.watch(responseStateProvider(activeId));
    final allMessages = ref.watch(allWebSocketMessagesProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponseSearch(),
          const SizedBox(height: 16),
          Expanded(
            child: responseAsync?.when(
                  data: (data) {
                    final messages = List.generate(
                      data?.length ?? 0,
                      (index) => data?[index] as WebSocketMessage,
                    );
                    final daviModel = createWebSocketResponseTable(
                      context,
                      messages,
                    );

                    return Davi<WebSocketMessage>(
                      key: Key('${activeId?.requestId}-${allMessages?.length}'),
                      daviModel,
                    );
                  },
                  error: (error, _) => Text('$error'),
                  loading: () => const ClientAoLoading(),
                ) ??
                const Text('No data'),
          ),
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
              ref.read(webSocketProvider.notifier).clearResponses();
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
