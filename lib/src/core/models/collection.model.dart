import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:client_ao/src/core/models/response.model.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionModel extends Equatable {
  final String id;
  final String? name;
  final RequestModel? requestModel;
  final AsyncValue<ResponseModel?>? response;

  const CollectionModel({
    required this.id,
    this.name,
    this.requestModel,
    this.response,
  });

  @override
  List<Object?> get props => [id, name, requestModel];

  CollectionModel copyWith({
    String? name,
    RequestModel? requestModel,
    AsyncValue<ResponseModel?>? response,
  }) {
    return CollectionModel(
      id: id,
      name: name ?? this.name,
      requestModel: requestModel ?? this.requestModel,
      response: response ?? this.response,
    );
  }
}
