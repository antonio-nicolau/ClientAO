import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/authentication_options.widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthTab extends ConsumerWidget {
  const AuthTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(selectedAuthOptionProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(auth.label),
        const SizedBox(width: 5),
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: _AuthTabSelectMethod(),
                  );
                },
              );
            },
            icon: const Icon(Icons.arrow_drop_down)),
      ],
    );
  }
}

class _AuthTabSelectMethod extends ConsumerWidget {
  const _AuthTabSelectMethod({super.key});

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
            color: e.method == auth.method ? Colors.grey[300] : Colors.transparent,
            padding: const EdgeInsets.all(8),
            child: Text(e.label),
          ),
        );
      }).toList(),
    );
  }
}
