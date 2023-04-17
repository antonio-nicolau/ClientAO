import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'enums.g.dart';

enum CollectionPopUpItem { edit, addRequest, addFolder }

@HiveType(typeId: 4)
enum RequestMethod {
  @HiveField(0)
  get,
  @HiveField(1)
  post,
  @HiveField(2)
  put,
  @HiveField(3)
  patch,
  @HiveField(4)
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
