import 'package:client_ao/src/core/constants/default_values.dart';
import 'package:client_ao/src/core/models/auth_options.model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedAuthOptionProvider = StateProvider<AuthOptionModel?>((ref) {
  return authMethodsOptions.last;
});

class AuthenticationOptions extends ConsumerWidget {
  const AuthenticationOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(selectedAuthOptionProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: authMethodsOptions.map((e) {
        return GestureDetector(
          onTap: () {
            ref.read(selectedAuthOptionProvider.notifier).state = e;
            Navigator.pop(context);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            color: e.method == auth?.method ? Colors.grey[300] : Colors.transparent,
            padding: const EdgeInsets.all(8),
            child: Text(e.label),
          ),
        );
      }).toList(),
    );
  }
}
