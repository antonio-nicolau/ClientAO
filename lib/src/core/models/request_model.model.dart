import 'package:client_ao/src/core/constants/enums.dart';
import 'package:client_ao/src/core/models/http_header.model.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestModel extends Equatable {
  final String? url;
  final String? body;
  final RequestMethod method;
  final List<KeyValueRow>? headers;
  final List<KeyValueRow>? urlParams;
  final String? name;
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
  List<Object?> get props => [url, method, headers, urlParams];
}

final requestModelProvider = StateProvider<RequestModel?>((ref) {
  return RequestModel();
});
