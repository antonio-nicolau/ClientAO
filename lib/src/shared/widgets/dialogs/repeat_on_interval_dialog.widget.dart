import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/widgets/dialogs/dialog_template.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RepeatOnIntervalDialog extends HookConsumerWidget {
  const RepeatOnIntervalDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldController = useTextEditingController();

    void sendRequest() {
      final text = double.tryParse(textFieldController.text) ?? 0.5;
      final interval = Duration(milliseconds: (text * 1000).toInt());

      ref.read(cancelRepeatRequestProvider.notifier).state = false;
      ref.read(collectionsNotifierProvider.notifier).sendRequest(requestInterval: interval);
      Navigator.pop(context);
    }

    return DialogTemplate(
      title: 'Send on Interval',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Interval in seconds'),
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
              child: const Text('Start'),
            ),
          ),
        ],
      ),
    );
  }
}
