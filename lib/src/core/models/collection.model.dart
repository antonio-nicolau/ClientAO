import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:equatable/equatable.dart';

class CollectionModel extends Equatable {
  final String id;
  final String? name;
  final RequestModel? requestModel;

  const CollectionModel({
    required this.id,
    this.name = 'New Request',
    this.requestModel,
  });

  @override
  List<Object?> get props => [id, name, requestModel];

  CollectionModel copyWith({String? name, RequestModel? requestModel}) {
    return CollectionModel(
      id: id,
      name: name ?? this.name,
      requestModel: requestModel ?? this.requestModel,
    );
  }
}
