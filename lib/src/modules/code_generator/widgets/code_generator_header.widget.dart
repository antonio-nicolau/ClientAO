import 'package:client_ao/src/modules/code_generator/code_generator.page.dart';
import 'package:client_ao/src/modules/code_generator/constants/codegen_constants.dart';
import 'package:client_ao/src/modules/code_generator/widgets/supported_languages_dropdown.widget.dart';
import 'package:client_ao/src/modules/code_generator/widgets/supported_packages_dropdown.widget.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CodeGeneratorHeader extends HookConsumerWidget {
  const CodeGeneratorHeader(this.code, {super.key});

  final String? code;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collection = ref.watch(collectionsNotifierProvider.notifier).getCollection();
    final requestModel = collection?.requests?.get(activeId?.requestId);

    useEffect(
      () {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          final languages = getSupportedLanguages(requestModel);

          ref.read(selectedSupportedLanguageProvider.notifier).update((state) => languages.first);
          ref.read(selectedSupportedPackageProvider.notifier).update((state) => languages.first.packages.first);
        });
        return;
      },
      [requestModel],
    );

    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_outlined),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                DropdownButtonSupportedLanguages(requestModel),
                const SizedBox(width: 8),
                DropdownButtonSupportedPackages(requestModel)
              ],
            ),
            ElevatedButton(
              onPressed: () {
                copyToClipboard(context: context, text: code);
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).colorScheme.surfaceVariant),
                  ),
                ),
              ),
              child: Text(
                'Copy to clipboard',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        )
      ],
    );
  }
}
