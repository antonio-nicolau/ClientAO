import 'package:client_ao/src/shared/constants/highlight_view_themes.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/github.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CodeHighlightView extends ConsumerWidget {
  const CodeHighlightView({
    super.key,
    required this.code,
    this.language,
    this.tabSize,
    this.withLineCount = false,
  });

  final String code;
  final String? language;
  final int? tabSize;
  final bool withLineCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themesProvider);

    return HighlightView(
      withLineCount ? identWithLinesCount(code) ?? '' : code,
      language: language ?? 'dart',
      theme: theme == ThemeMode.dark ? dartHighlightViewDarkTheme : githubTheme,
      tabSize: tabSize ?? 8,
    );
  }
}
