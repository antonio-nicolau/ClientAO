import 'dart:convert';
import 'dart:io';
import 'package:client_ao/src/shared/models/auth/base_auth.interface.model.dart';

class AuthBasicModel implements BaseAuth {
  final String? username;
  final String? password;
  final bool enabled;

  const AuthBasicModel({this.username, this.password, this.enabled = false});

  @override
  Map<String, String> toKeyValue() {
    final basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    return {HttpHeaders.authorizationHeader: basicAuth};
  }

  AuthBasicModel copyWith({String? username, String? password, bool? enabled}) {
    return AuthBasicModel(
      username: username ?? this.username,
      password: password ?? this.password,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  bool isEnabled() => enabled;
}
