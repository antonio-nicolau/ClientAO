import 'package:client_ao/src/modules/code_generator/code_generator.page.dart';
import 'package:client_ao/src/modules/code_generator/constants/codegen_constants.dart';
import 'package:client_ao/src/modules/code_generator/models/supported_language.model.dart';
import 'package:client_ao/src/shared/models/base_request.interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DropdownButtonSupportedLanguages extends HookConsumerWidget {
  const DropdownButtonSupportedLanguages(this.requestModel, {super.key});

  final BaseRequestModel? requestModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = useMemoized(
      () => getSupportedLanguages(requestModel),
      [requestModel],
    );

    final supportedLanguage = useState<SupportedLanguage>(languages.first);

    return DropdownButton<SupportedLanguage>(
      focusColor: Theme.of(context).colorScheme.surface,
      value: supportedLanguage.value,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      onChanged: (SupportedLanguage? value) {
        if (value != null) {
          supportedLanguage.value = value;
          ref.read(selectedSupportedLanguageProvider.notifier).state = value;
          ref.read(selectedSupportedPackageProvider.notifier).state = value.packages.first;
        }
      },
      items: languages.map<DropdownMenuItem<SupportedLanguage>>((SupportedLanguage value) {
        return DropdownMenuItem<SupportedLanguage>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value.language.name.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
