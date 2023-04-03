import 'dart:io';

import 'package:client_ao/src/modules/home/widgets/sections/request/auth_tab/bearer_token.widget.dart';
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
    final authorization = _ref.read(bearerAuthenticationProvider);

    if (authorization.enabled) {
      request.headers[HttpHeaders.authorizationHeader] = authorization.toTokenScheme();
    }

    return _inner.send(request);
  }
}
