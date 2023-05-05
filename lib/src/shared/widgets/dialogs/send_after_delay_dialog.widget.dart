
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/widgets/dialogs/dialog_template.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SendAfterDelayDialog extends HookConsumerWidget {
  const SendAfterDelayDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldController = useTextEditingController();

    void sendRequest() {
      final delay = Duration(seconds: int.tryParse(textFieldController.text) ?? 0);

      ref.read(collectionsNotifierProvider.notifier).sendRequest(sendAfterDelay: delay);
      Navigator.pop(context);
    }

    return DialogTemplate(
      title: 'Send After Delay',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delay in seconds'),
          const SizedBox(height: 8),
          TextField(
            controller: textFieldController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '0',
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: FilledButton(
              onPressed: sendRequest,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
