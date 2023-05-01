import 'package:client_ao/src/shared/models/key_value_row.model.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:client_ao/src/shared/widgets/environment_suggestions.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final overlayEntryProvider = StateProvider<OverlayEntry?>((ref) {
  return null;
});

final textFieldValueProvider = StateProvider<String?>((ref) {
  return null;
});

class CustomValueTextField extends HookConsumerWidget {
  const CustomValueTextField({
    super.key,
    required this.index,
    this.valueFieldHintText,
    this.onValueFieldChanged,
    this.rows,
    required this.defaultValue,
    required this.parentContext,
  });
  final int index;
  final String? valueFieldHintText;
  final Function(String)? onValueFieldChanged;
  final List<KeyValueRow>? rows;
  final String? defaultValue;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerController = useTextEditingController(text: defaultValue);
    final focusNode = useFocusNode();

    useEffect(
      () {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          removeOverlay(ref);

          createOverlayEntry(context, ref, headerController, focusNode);
        });
        return;
      },
      [],
    );

    return TextField(
      controller: headerController,
      decoration: InputDecoration(
        hintText: valueFieldHintText ?? 'value',
        hintStyle: Theme.of(parentContext).inputDecorationTheme.hintStyle,
      ),
      style: Theme.of(parentContext).textTheme.titleMedium,
      onChanged: (value) {
        ref.read(textFieldValueProvider.notifier).update((state) => value);

        showEnvironmentVariablesSuggestions(context, ref);

        onValueFieldChanged?.call(value);
      },
    );
  }

  void createOverlayEntry(
    BuildContext? buildContext,
    WidgetRef ref,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    final response = getWidgetSize(buildContext);

    final dx = response.$0;
    final dy = response.$1;
    final size = response.$2;

    ref.read(overlayEntryProvider.notifier).state = OverlayEntry(
      builder: (BuildContext context) {
        return SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: dy + 35,
                left: dx,
                child: SizedBox(
                  width: size.width,
                  child: ListViewWithSuggestions(
                    controller: controller,
                    focusNode: focusNode,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showEnvironmentVariablesSuggestions(BuildContext context, WidgetRef ref) {
    final overlayEntry = ref.read(overlayEntryProvider);

    removeOverlay(ref);

    if (overlayEntry == null) return;

    Overlay.of(parentContext, debugRequiredFor: this).insert(overlayEntry);
  }
}

void removeOverlay(WidgetRef ref) {
  if (ref.read(overlayEntryProvider) != null && ref.read(overlayEntryProvider)?.mounted == true) {
    ref.read(overlayEntryProvider)?.remove();
  }
}
