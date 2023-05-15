import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/base_response.interface.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'websocket_message.model.g.dart';

@HiveType(typeId: 8)
class WebSocketMessage extends Equatable implements BaseResponseModel {
  @HiveField(0)
  final String? message;

  @HiveField(1)
  final String? time;

  @HiveField(2)
  final SentFrom? from;

  @HiveField(3)
  final SocketConnectionStatus? status;

  const WebSocketMessage({
    this.message,
    this.from,
    this.status,
    this.time,
  });

  @override
  List<Object?> get props => [message, time, from, status];
}
