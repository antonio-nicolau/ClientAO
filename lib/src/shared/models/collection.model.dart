import 'package:client_ao/src/shared/models/base_request.interface.dart';
import 'package:client_ao/src/shared/models/base_response.interface.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'collection.model.g.dart';

@HiveType(typeId: 3)
class CollectionModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final List<BaseRequestModel?>? requests;

  @HiveField(3)
  final List<BaseResponseModel?>? responses;

  @HiveField(4)
  final List<String>? folders;

  const CollectionModel({
    required this.id,
    this.name = "New collection",
    this.requests,
    this.responses,
    this.folders,
  });

  @override
  List<Object?> get props => [id, name, requests, responses, folders];

  CollectionModel copyWith({
    String? name,
    List<BaseRequestModel?>? requests,
    List<BaseResponseModel?>? responses,
  }) {
    return CollectionModel(
      id: id,
      name: name ?? this.name,
      requests: requests ?? this.requests,
      responses: responses ?? this.responses,
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
