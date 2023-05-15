import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/websocket/states/websocket.state.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/websocket_message.model.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_parser/http_parser.dart';

class WebSocketRequestBody extends HookConsumerWidget {
  /// widget to build WebSocket request body, it contains a `Send` button
  const WebSocketRequestBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final defaultValue = ref.watch(collectionsNotifierProvider.notifier).getCollection()?.requests?.get(activeId?.requestId ?? 0)?.body;
    final bodyController = useTextEditingController(
      text: formatBody(defaultValue, MediaType('text', 'json')),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(top: 16, right: 8),
            child: FilledButton(
              onPressed: () => sendData(ref, bodyController.text.trim()),
              child: const Text('Send'),
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: TextField(
            controller: bodyController,
            keyboardType: TextInputType.multiline,
            minLines: 30,
            maxLines: 80,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              hintText: 'Message',
            ),
          ),
        ),
      ],
    );
  }

  void sendData(WidgetRef ref, String data) {
    if (data.isNotEmpty && ref.read(webSocketProvider) != null) {
      final message = WebSocketMessage(
        message: data,
        from: SentFrom.local,
        status: SocketConnectionStatus.sending,
        time: getFormattedTime(),
      );

      ref.read(webSocketProvider.notifier)
        ..addMessage(message)
        ..send(data);
    }
  }
}
