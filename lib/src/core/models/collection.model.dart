import 'package:client_ao/src/core/models/request_model.model.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

class CollectionModel extends Equatable {
  final String id;
  final String? name;
  final RequestModel? requestModel;
  final AsyncValue<Response?>? response;

  const CollectionModel({
    required this.id,
    this.name = 'New Request',
    this.requestModel,
    this.response,
  });

  @override
  List<Object?> get props => [id, name, requestModel];

  CollectionModel copyWith({
    String? name,
    RequestModel? requestModel,
    AsyncValue<Response?>? response,
  }) {
    return CollectionModel(
      id: id,
      name: name ?? this.name,
      requestModel: requestModel ?? this.requestModel,
      response: response ?? this.response,
    );
  }
}
