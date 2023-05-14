import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:equatable/equatable.dart';

class WebSocketMessage extends Equatable {
  final String message;
  final String time;
  final SentFrom from;
  final SocketConnectionStatus status;

  const WebSocketMessage({
    required this.message,
    required this.from,
    required this.status,
    required this.time,
  });

  @override
  List<Object?> get props => [message, time, from, status];
}
