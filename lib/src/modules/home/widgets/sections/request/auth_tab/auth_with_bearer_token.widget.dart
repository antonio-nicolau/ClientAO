import 'package:client_ao/src/core/models/auth/bearer_token.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authWithBearerTokenProvider = StateProvider<BearerAuthentication>((ref) {
  return const BearerAuthentication();
});

class AuthWithBearerToken extends HookConsumerWidget {
  const AuthWithBearerToken({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bearerAuth = ref.watch(authWithBearerTokenProvider);
    final bearerTokenController = useTextEditingController(text: bearerAuth.token);

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
                value: bearerAuth.enabled,
                onChanged: (value) {
                  ref.read(authWithBearerTokenProvider.notifier).state = bearerAuth.copyWith(
                    enabled: !bearerAuth.enabled,
                  );
                },
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('TOKEN'),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: bearerTokenController,
                  onChanged: (value) {
                    ref.read(authWithBearerTokenProvider.notifier).state = bearerAuth.copyWith(
                      token: value,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
