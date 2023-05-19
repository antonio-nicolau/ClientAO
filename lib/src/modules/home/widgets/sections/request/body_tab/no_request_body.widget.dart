import 'package:client_ao/src/shared/constants/strings.dart';
import 'package:client_ao/src/shared/utils/theme/app_theme.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoRequestBody extends ConsumerWidget {
  /// widget to be displayed when `no body or not supported` type is selected
  const NoRequestBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themMode = ref.watch(themesProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(enterUrlAndSend),
          const SizedBox(height: 16),
          Divider(
            color: themMode == ThemeMode.dark ? Colors.white70 : Theme.of(context).colorScheme.surfaceVariant,
          ),
          const SizedBox(height: 16),
          const Text(selectBodyTypeAbove, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
