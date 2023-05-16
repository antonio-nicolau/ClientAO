import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/home/widgets/websocket/request/url_card/websocket_send_request_button.widget.dart';
import 'package:client_ao/src/modules/home/widgets/websocket/states/websocket.state.dart';
import 'package:client_ao/src/shared/constants/strings.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebSocketUrlCard extends HookConsumerWidget {
  /// Widget responsible to build request URL card
  const WebSocketUrlCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collection = ref.watch(collectionsNotifierProvider.notifier).getCollection();
    final url = collection?.requests?.get(activeId?.requestId)?.url;
    final urlController = useTextEditingController(text: url);
    final focusNode = useFocusNode();

    useEffect(
      () {
        urlController.text = url ?? '';
        return;
      },
      [activeId],
    );

    void sendRequest() {
      final channel = ref.read(webSocketProvider);
      final request = collection?.requests?[activeId?.requestId ?? 0];

      if (channel != null) {
        ref.read(webSocketProvider.notifier).disconnect();

        return;
      }

      if (request != null) {
        ref.read(collectionsNotifierProvider.notifier).send();
      }
      focusNode.requestFocus();
    }

    return SizedBox(
      height: 50,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Text(
                'WS',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.amber),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: urlController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: wsUrlHintText,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: (value) {
                  ref.read(collectionsNotifierProvider.notifier).updateRequest(url: value);
                },
                onSubmitted: (value) => sendRequest.call(),
              ),
            ),
            WebSocketSendRequestButton(
              collection: collection,
              onPressed: sendRequest,
            ),
          ],
        ),
      ),
    );
  }
}
