import 'package:client_ao/src/core/models/base_auth.interface.model.dart';
import 'package:client_ao/src/core/models/http_header.model.dart';

class AuthApiKeyModel implements BaseAuth {
  final HttpHeader? keyValue;
  final bool enabled;

  const AuthApiKeyModel({this.keyValue, this.enabled = false});

  @override
  Map<String, String> toKeyValue() {
    return {'${keyValue?.key}': '${keyValue?.value}'};
  }

  AuthApiKeyModel copyWith({HttpHeader? keyValue, bool? enabled}) {
    return AuthApiKeyModel(
      keyValue: keyValue ?? this.keyValue,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  bool isEnabled() => enabled;
}
