import 'package:client_ao/src/modules/home/widgets/sections/request/url_card/send_request_popup_menu.widget.dart';
import 'package:client_ao/src/shared/models/collection.model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SendRequestButton extends ConsumerWidget {
  const SendRequestButton({
    super.key,
    required this.collection,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final CollectionModel? collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.deepPurpleAccent.shade100,
      child: Row(
        children: [
          FilledButton(
            onPressed: onPressed,
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              )),
            ),
            child: const Text('Send'),
          ),
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
