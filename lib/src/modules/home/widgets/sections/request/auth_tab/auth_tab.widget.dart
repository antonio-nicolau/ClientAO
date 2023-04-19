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
        Expanded(child: Text(auth?.displayName ?? '', maxLines: 1)),
        const SizedBox(width: 5),
        IconButton(
          onPressed: () => showAuthOptions(context),
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }

  void showAuthOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(content: AuthenticationOptions());
      },
    );
  }
}
