import 'package:client_ao/src/core/services/hive.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnvironmentNameTextField extends HookConsumerWidget {
  const EnvironmentNameTextField({
    super.key,
    required this.index,
    required this.envName,
    required this.selectedValue,
    required this.onTap,
  });

  final int index;
  final String envName;
  final VoidCallback onTap;
  final String selectedValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envNameController = useTextEditingController(text: envName);
    final enableTextField = useState<bool>(false);

    return GestureDetector(
      onTap: () {
        if (!enableTextField.value) onTap.call();
      },
      onDoubleTap: () => enableTextField.value = true,
      child: TextField(
        enabled: enableTextField.value,
        controller: envNameController,
        readOnly: !enableTextField.value,
        decoration: InputDecoration(
          filled: envName == selectedValue,
          fillColor: envName == selectedValue ? Colors.grey[300] : Colors.transparent,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            ref.read(hiveServiceProvider).saveEnvironment(
                  index: index,
                  envName: envNameController.text.trim(),
                );
          }
        },
        onSubmitted: (value) {
          if (!enableTextField.value) enableTextField.value = false;
        },
      ),
    );
  }
}
