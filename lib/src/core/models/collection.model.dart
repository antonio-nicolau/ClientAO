import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/models/response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionModel extends Equatable {
  final String id;
  final String? name;
  final List<RequestModel?>? requestModel;
  final List<AsyncValue<ResponseModel?>?>? response;

  const CollectionModel({
    required this.id,
    this.name = "New collection",
    this.requestModel,
    this.response,
  });

  @override
  List<Object?> get props => [id, name, requestModel];

  CollectionModel copyWith({
    String? name,
    List<RequestModel?>? requestModel,
    List<AsyncValue<ResponseModel?>?>? response,
  }) {
    return CollectionModel(
      id: id,
      name: name ?? this.name,
      requestModel: requestModel ?? this.requestModel,
      response: response ?? this.response,
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
