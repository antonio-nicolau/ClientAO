import 'dart:developer';

import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/base_auth.interface.model.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/auth_with_api_key.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/authentication_options.widget.dart';
import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/auth_with_bearer_token.widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient(http.Client(), ref);
});

class HttpClient extends http.BaseClient {
  final http.Client _inner;
  final Ref _ref;

  HttpClient(this._inner, this._ref);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final response = getAuthorizationMethod();

    if (response != null && response.isEnabled()) {
      request.headers.addAll(response.toKeyValue());
    }

    return _inner.send(request);
  }

  BaseAuth? getAuthorizationMethod() {
    final authMethod = _ref.read(selectedAuthOptionProvider);

    switch (authMethod.method) {
      case AuthMethod.apiKeyAuth:
        final keyValue = _ref.read(authWithApiKeyProvider);
        return keyValue;
      case AuthMethod.bearerToken:
        final keyValue = _ref.read(authWithBearerTokenProvider);
        return keyValue;
      case AuthMethod.basic:
        // TODO: Handle this case.
        log('To be implemented');
        return null;
      case AuthMethod.noAuthentication:
        return null;
    }
  }
}
