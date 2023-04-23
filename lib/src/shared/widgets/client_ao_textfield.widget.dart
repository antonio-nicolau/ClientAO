import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClientAoTextField extends HookConsumerWidget {
  /// Custom [TextField], it support "Edit on double click"
  /// Disabled by default
  /// [defaultValue] - value displayed when TextField is rendered on the screen
  /// [onValueChange] - when user double click and start editing this method is called
  /// [saveOnEditingComplete] - true by default, call [onValueChange] when submit text
  /// [saveOnTapOutside] - true by default, same behavior as [saveOnEditingComplete]
  const ClientAoTextField({
    super.key,
    this.defaultValue,
    this.onValueChange,
    this.saveOnTapOutside = true,
    this.saveOnEditingComplete = true,
    this.hintText,
    this.maxLines,
    this.minLines,
    this.style,
    this.disabledBorder,
    this.focusedBorder,
    this.contentPadding,
  });

  final String? defaultValue;
  final Function(String)? onValueChange;
  final bool saveOnTapOutside;
  final bool saveOnEditingComplete;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final TextStyle? style;
  final InputBorder? disabledBorder;
  final InputBorder? focusedBorder;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldController = useTextEditingController(text: defaultValue);
    final enableTextField = useState<bool>(false);

    return GestureDetector(
      onDoubleTap: () => enableTextField.value = true,
      child: TextField(
        enabled: enableTextField.value,
        controller: textFieldController,
        readOnly: !enableTextField.value,
        decoration: InputDecoration(
          disabledBorder: disabledBorder ?? InputBorder.none,
          focusedBorder: focusedBorder ?? InputBorder.none,
          contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(0, 8, 0, 8),
        ),
        style: style ?? Theme.of(context).textTheme.bodyMedium,
        maxLines: maxLines,
        onEditingComplete: () {
          final value = textFieldController.text.trim();
          enableTextField.value = false;
          if (value.isNotEmpty && saveOnEditingComplete) {
            onValueChange?.call(value);
          }
        },
        onSubmitted: (value) {
          if (!enableTextField.value) enableTextField.value = false;
        },
        onTapOutside: (event) {
          if (enableTextField.value) {
            final value = textFieldController.text.trim();

            enableTextField.value = false;
            if (value.isNotEmpty && saveOnTapOutside) {
              onValueChange?.call(value);
            }
          }
        },
      ),
    );
  }
}
