import 'dart:convert';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
import 'package:client_ao/src/shared/code_generator/dart/dart_code_generator.dart';
import 'package:client_ao/src/shared/constants/highlight_view_themes.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:flutter/material.dart';
import 'package:client_ao/src/shared/utils/client_ao_extensions.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CodeGenPage extends ConsumerWidget {
  const CodeGenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdProvider);
    final collection = ref.watch(collectionsNotifierProvider.notifier).getCollection();
    final requestModel = collection?.requests?.get(activeId?.requestId);
    final code = DartCodeGenerator.getCode(requestModel);

    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade900,
      child: ListView(
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
              Text(
                'Dart',
                style: Theme.of(context).textTheme.titleMedium,
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
          ),
          const SizedBox(height: 8),
          Divider(color: Theme.of(context).colorScheme.surfaceVariant),
          const SizedBox(height: 16),
          HighlightView(
            identWithLinesCount(code) ?? '',
            language: 'dart',
            theme: dartHighlightViewDarkTheme,
          ),
        ],
      ),
    );
  }

  String? identWithLinesCount(String? code) {
    if (code == null) return null;

    final lines = const LineSplitter().convert(code);

    for (var i = 0; i < lines.length; i++) {
      lines[i] = '${(i + 1)}${' ' * 8}${lines[i]}\n';
    }

    return lines.join();
  }
}
