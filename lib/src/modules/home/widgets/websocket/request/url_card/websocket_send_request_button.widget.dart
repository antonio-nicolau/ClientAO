import 'package:client_ao/src/modules/home/widgets/sections/request/url_card/send_request_popup_menu.widget.dart';
import 'package:client_ao/src/modules/home/widgets/websocket/states/websocket.state.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WebSocketSendRequestButton extends ConsumerWidget {
  const WebSocketSendRequestButton({
    super.key,
    required this.collection,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final CollectionModel? collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(webSocketProvider);

    return Container(
      color: channel != null ? Colors.red : Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          FilledButton(
            onPressed: onPressed,
            style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                )),
                backgroundColor: MaterialStateProperty.all<Color?>(
                  channel != null ? Colors.red : null,
                )),
            child: Text(
              channel == null ? 'Connect' : 'Disconnect',
              style: TextStyle(
                color: channel != null ? Colors.white : null,
              ),
            ),
          ),
          if (channel == null)
            PopUpSendMenu(
              collection: collection,
              widgetRef: ref,
              parentContext: context,
            ),
        ],
      ),
    );
  }
}
