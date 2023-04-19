import 'package:hive/hive.dart';
part 'enums.g.dart';

enum CollectionPopUpItem { edit, addRequest, addFolder }

enum RequestPopUpItem { delete }

@HiveType(typeId: 4)
enum HttpVerb {
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

enum AuthMethod {
  apiKeyAuth,
  bearerToken,
  basic,
  noAuthentication,
}
