import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/auth_basic.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/auth_with_api_key.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/authentication_options.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/auth_with_bearer_token.widget.dart';
import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthLayoutBasedOnMethod extends ConsumerWidget {
  const AuthLayoutBasedOnMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(selectedAuthOptionProvider);

    switch (auth?.method) {
      case AuthMethod.apiKeyAuth:
        return const AuthWithApiKey();
      case AuthMethod.bearerToken:
        return const AuthWithBearerToken();

      case AuthMethod.basic:
        return const AuthBasic();
      case AuthMethod.noAuthentication:
        return const NoAuthenticationSelected();
      default:
        return const NoAuthenticationSelected();
    }
  }
}

class NoAuthenticationSelected extends ConsumerWidget {
  const NoAuthenticationSelected({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          const Icon(Icons.lock, size: 100),
          const SizedBox(height: 16),
          Text(
            'Select an auth type from above 🙂',
            style: Theme.of(context).textTheme.labelLarge,
          )
        ],
      ),
    );
  }
}
