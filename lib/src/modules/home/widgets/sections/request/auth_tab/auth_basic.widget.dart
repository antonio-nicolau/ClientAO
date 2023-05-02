import 'package:client_ao/src/shared/models/auth/auth_basic.model.dart';
import 'package:client_ao/src/shared/widgets/custom_textfield.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authBasicProvider = StateProvider<AuthBasicModel>((ref) {
  return const AuthBasicModel();
});

class AuthBasic extends HookConsumerWidget {
  const AuthBasic({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basicAuthState = ref.watch(authBasicProvider);
    final userController = useTextEditingController(text: basicAuthState.username);
    final passwordController = useTextEditingController(text: basicAuthState.password);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'ENABLED',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              Checkbox(
                value: basicAuthState.enabled,
                onChanged: (value) {
                  ref.read(authBasicProvider.notifier).update(
                        (state) => state.copyWith(
                          enabled: !basicAuthState.enabled,
                        ),
                      );
                },
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('USERNAME'),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: userController,
                  onChanged: (value) {
                    ref.read(authBasicProvider.notifier).state = basicAuthState.copyWith(
                      username: value,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('PASSWORD'),
              const SizedBox(width: 16),
              Expanded(
                child: CustomValueTextField(
                  onValueFieldChanged: (value) {
                    ref.read(authBasicProvider.notifier).state = basicAuthState.copyWith(
                      password: value,
                    );
                  },
                  parentContext: context,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
