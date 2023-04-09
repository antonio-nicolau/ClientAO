import 'package:equatable/equatable.dart';

enum CollectionPopUpItem { edit, addRequest, addFolder }

enum RequestMethod {
  get,
  post,
  put,
  patch,
  delete,
}

class Auth extends Equatable {
  final String label;
  final AuthMethod method;

  const Auth({required this.label, required this.method});

  @override
  List<Object?> get props => [label, method.name];
}

enum AuthMethod {
  apiKeyAuth,
  bearerToken,
  basic,
  noAuthentication,
}

const authMethodsOptions = [
  Auth(label: 'Api Key', method: AuthMethod.apiKeyAuth),
  Auth(label: 'Bearer', method: AuthMethod.bearerToken),
  Auth(label: 'Basic', method: AuthMethod.basic),
  Auth(label: 'Auth', method: AuthMethod.noAuthentication),
];
