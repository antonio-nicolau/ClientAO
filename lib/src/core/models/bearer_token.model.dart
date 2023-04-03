import 'dart:io';

import 'package:client_ao/src/core/models/base_auth.interface.model.dart';

class BearerAuthentication implements BaseAuth {
  final String? token;
  final bool enabled;

  const BearerAuthentication({this.token, this.enabled = false});

  @override
  Map<String, String> toKeyValue() {
    return {HttpHeaders.authorizationHeader: 'Bearer $token'};
  }

  BearerAuthentication copyWith({String? token, bool? enabled}) {
    return BearerAuthentication(
      token: token ?? this.token,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  bool isEnabled() => enabled;
}
