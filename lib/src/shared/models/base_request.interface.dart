import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/key_value_row.model.dart';

abstract class BaseRequestModel {
  final String? url;

  final String? body;

  final HttpVerb method;

  final List<KeyValueRow>? headers;

  final List<KeyValueRow>? urlParams;

  final String? name;

  final String? folderId;

  const BaseRequestModel({
    this.url,
    this.body,
    this.method = HttpVerb.get,
    this.headers,
    this.urlParams,
    this.name,
    this.folderId,
  });

  BaseRequestModel copyWith({
    Uri? uri,
    String? url,
    String? body,
    HttpVerb? method,
    List<KeyValueRow>? headers,
    List<KeyValueRow>? urlParams,
    String? name,
    String? folderId,
  });
}
