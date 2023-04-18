import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/key_value_row.model.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
part 'request_model.model.g.dart';

@HiveType(typeId: 0)
class RequestModel extends Equatable {
  @HiveField(0)
  final String? url;

  @HiveField(1)
  final String? body;

  @HiveField(2)
  final RequestMethod method;

  @HiveField(3)
  final List<KeyValueRow>? headers;

  @HiveField(4)
  final List<KeyValueRow>? urlParams;

  @HiveField(5)
  final String? name;

  @HiveField(6)
  final String? folderId;

  RequestModel({
    this.url,
    this.body,
    this.method = RequestMethod.get,
    this.headers,
    this.urlParams,
    this.name,
    this.folderId,
  });

  RequestModel copyWith({
    Uri? uri,
    String? url,
    String? body,
    RequestMethod? method,
    List<KeyValueRow>? headers,
    List<KeyValueRow>? urlParams,
    String? name,
    String? folderId,
  }) {
    return RequestModel(
      url: url ?? this.url,
      body: body ?? this.body,
      name: name ?? this.name,
      folderId: folderId ?? this.folderId,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      urlParams: urlParams ?? this.urlParams,
    );
  }

  @override
  List<Object?> get props => [url, body, name, folderId, method, headers, urlParams];
}

final requestModelProvider = StateProvider<RequestModel?>((ref) {
  return RequestModel();
});
