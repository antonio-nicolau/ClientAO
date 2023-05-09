import 'package:client_ao/src/modules/code_generator/models/supported_language.model.dart';
import 'package:client_ao/src/modules/code_generator/models/supported_package.model.dart';
import 'package:client_ao/src/modules/code_generator/widgets/code_generator_header.widget.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/modules/code_generator/services/codegen.service.dart';
import 'package:client_ao/src/shared/widgets/code_highlight_view.widget.dart';
import 'package:flutter/material.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedSupportedLanguageProvider = StateProvider<SupportedLanguage?>((ref) {
  return null;
});

final selectedSupportedPackageProvider = StateProvider<SupportedPackage?>((ref) {
  return null;
});

class CodeGenPage extends HookConsumerWidget {
  /// Responsible to show Codegen page
  /// Code is displayed based on [SupportedLanguage] and [SupportedPackage]
  const CodeGenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collection = ref.watch(collectionsNotifierProvider.notifier).getCollection();
    final requestModel = collection?.requests?.get(activeId?.requestId);
    final language = ref.watch(selectedSupportedLanguageProvider);
    final code = ref.watch(codegenServiceProvider(requestModel));

    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          CodeGeneratorHeader(code),
          const SizedBox(height: 8),
          Divider(color: Theme.of(context).colorScheme.surfaceVariant),
          const SizedBox(height: 16),
          CodeHighlightView(
            code: code ?? '',
            language: language?.highlightLanguage,
            withLineCount: true,
          ),
        ],
      ),
    );
  }
}
