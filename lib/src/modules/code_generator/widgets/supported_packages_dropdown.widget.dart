import 'package:client_ao/src/modules/code_generator/code_generator.page.dart';
import 'package:client_ao/src/modules/code_generator/models/supported_package.model.dart';
import 'package:client_ao/src/shared/models/base_request.interface.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DropdownButtonSupportedPackages extends HookConsumerWidget {
  const DropdownButtonSupportedPackages(this.requestModel, {super.key});

  final BaseRequestModel? requestModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(selectedSupportedLanguageProvider);

    return DropdownButton<SupportedPackage>(
      focusColor: Theme.of(context).colorScheme.surface,
      value: ref.watch(selectedSupportedPackageProvider),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      onChanged: (SupportedPackage? value) {
        if (value != null) {
          ref.read(selectedSupportedPackageProvider.notifier).update((state) => value);
        }
      },
      items: language?.packages.map<DropdownMenuItem<SupportedPackage>>((SupportedPackage value) {
        return DropdownMenuItem<SupportedPackage>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value.label,
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
