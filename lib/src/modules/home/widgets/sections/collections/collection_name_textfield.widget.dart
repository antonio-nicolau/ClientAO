import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionNameTextField extends HookConsumerWidget {
  const CollectionNameTextField(this.requestName, {super.key});

  final String requestName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionNameController = useTextEditingController(text: requestName);
    final enableTextField = useState<bool>(false);

    return GestureDetector(
      onDoubleTap: () => enableTextField.value = true,
      child: TextField(
        enabled: enableTextField.value,
        controller: collectionNameController,
        readOnly: !enableTextField.value,
        decoration: const InputDecoration(
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        onEditingComplete: () {
          final value = collectionNameController.text.trim();
          enableTextField.value = false;
          if (value.isNotEmpty) {
            ref.read(collectionsNotifierProvider.notifier).updateRequest(name: value);
          }
        },
        onSubmitted: (value) {
          if (!enableTextField.value) enableTextField.value = false;
        },
        onTapOutside: (event) {
          if (enableTextField.value) {
            final value = collectionNameController.text.trim();

            enableTextField.value = false;
            if (value.isNotEmpty) {
              ref.read(collectionsNotifierProvider.notifier).updateRequest(name: value);
            }
          }
        },
      ),
    );
  }
}
