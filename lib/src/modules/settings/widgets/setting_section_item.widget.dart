import 'package:client_ao/src/shared/widgets/text_fields/textField_with_environment_suggestion.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingSectionItem extends ConsumerWidget {
  const SettingSectionItem({
    super.key,
    this.label,
    this.buttonText,
    this.textfieldDefaultValue,
    this.hasTextField = true,
    this.hasButton = false,
    this.onButtonClick,
    this.onChanged,
  });

  final String? label;
  final String? buttonText;
  final String? textfieldDefaultValue;
  final Function(String value)? onChanged;
  final VoidCallback? onButtonClick;
  final bool hasTextField;
  final bool hasButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label ?? ''),
          const SizedBox(height: 8),
        ],
        if (hasTextField)
          TextFieldWithEnvironmentSuggestion(
            defaultValue: textfieldDefaultValue,
            parentContext: context,
            displaySuggestion: false,
            onChanged: onChanged,
          ),
        if (hasButton) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: onButtonClick,
              child: Text(buttonText ?? ''),
            ),
          ),
        ]
      ],
    );
  }
}
