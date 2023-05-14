import 'package:hive/hive.dart';
part 'enums.g.dart';

enum SentFrom { local, remote }

enum SocketConnectionStatus { connected, disconnected, sending, receiving }

enum ProgramLanguages { dart, nodeJs }

enum Packages { http, axios }

enum CollectionPopUpItem { addRequest, delete }

enum SendPopUpItem { send, generateCode, repeatRequest, sendAfterDelay }

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
  @HiveField(5)
  head,
}

enum AuthMethod {
  apiKeyAuth,
  bearerToken,
  basic,
  noAuthentication,
}

class Protocol {
  static const http = 'http://';
  static const https = 'https://';
  static const smtp = 'smtp://';
  static List<String> values = [http, https, smtp];
}
