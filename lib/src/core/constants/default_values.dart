import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/auth_options.model.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

const authMethodsOptions = [
  AuthOptionModel(label: 'API Key Auth', displayName: 'API Key', method: AuthMethod.apiKeyAuth),
  AuthOptionModel(label: 'Bearer Token', displayName: 'Bearer', method: AuthMethod.bearerToken),
  AuthOptionModel(label: 'Basic Auth', displayName: 'Basic', method: AuthMethod.basic),
  AuthOptionModel(label: 'No Authentication', displayName: 'Auth', method: AuthMethod.noAuthentication),
];
