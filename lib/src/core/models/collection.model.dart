import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/models/response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionModel extends Equatable {
  final String id;
  final String? name;
  final List<RequestModel?>? requests;
  final List<AsyncValue<ResponseModel?>?>? responses;

  const CollectionModel({
    required this.id,
    this.name = "New collection",
    this.requests,
    this.responses,
  });

  @override
  List<Object?> get props => [id, name, requests];

  CollectionModel copyWith({
    String? name,
    List<RequestModel?>? requestModel,
    List<AsyncValue<ResponseModel?>?>? response,
  }) {
    return CollectionModel(
      id: id,
      name: name ?? this.name,
      requests: requestModel ?? this.requests,
      responses: response ?? this.responses,
    );
  }
}

class ActiveId {
  final String? collection;
  final int? requestId;
  final String? folder;

  ActiveId({this.collection, this.requestId, this.folder});

  ActiveId copyWith({String? collection, int? requestId, String? folder}) {
    return ActiveId(
      collection: collection ?? this.collection,
      requestId: requestId ?? this.requestId,
      folder: folder ?? this.folder,
    );
  }
}
