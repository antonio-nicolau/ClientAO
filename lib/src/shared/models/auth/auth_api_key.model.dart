import 'package:client_ao/src/shared/models/auth/base_auth.interface.model.dart';
import 'package:client_ao/src/shared/models/key_value_row.model.dart';

class AuthApiKeyModel implements BaseAuth {
  final KeyValueRow? keyValue;
  final bool enabled;

  const AuthApiKeyModel({this.keyValue, this.enabled = false});

  @override
  Map<String, String> toKeyValue() {
    return {'${keyValue?.key}': '${keyValue?.value}'};
  }

  AuthApiKeyModel copyWith({KeyValueRow? keyValue, bool? enabled}) {
    return AuthApiKeyModel(
      keyValue: keyValue ?? this.keyValue,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  bool isEnabled() => enabled;
}
