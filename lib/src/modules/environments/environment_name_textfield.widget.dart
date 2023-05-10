import 'package:client_ao/src/modules/environments/manage_environment.widget.dart';
import 'package:client_ao/src/shared/services/cache/environment_hive.service.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.dart';
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
    final currentIndex = ref.watch(envIndexProvider);
    final enableTextField = useState<bool>(false);
    final appColors = ref.watch(appColorsProvider);

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
          filled: index == currentIndex,
          fillColor: index == currentIndex ? appColors.selectedColor() : Colors.transparent,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            ref.read(environmentHiveServiceProvider).saveEnvironment(
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
