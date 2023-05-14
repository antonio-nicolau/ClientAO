import 'package:client_ao/src/shared/constants/enums.dart';
import 'package:client_ao/src/shared/models/websocket_message.model.dart';
import 'package:client_ao/src/shared/utils/functions.utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final allWebSocketMessagesProvider = StateProvider<List<WebSocketMessage>?>((ref) {
  return [];
});

final webSocketProvider = StateNotifierProvider<WebSocketNotifier, WebSocketChannel?>((ref) {
  return WebSocketNotifier(ref);
});

// A streamNotifier to listen for incoming messages from WebSocket channel
final webSocketStreamProvider = StreamProvider<List<WebSocketMessage>?>((ref) async* {
  final channel = ref.watch(webSocketProvider);

  if (channel != null) {
    await for (final data in channel.stream.map((e) => e)) {
      var allMessages = ref.read(allWebSocketMessagesProvider) ?? <WebSocketMessage>[];

      final message = WebSocketMessage(
        message: data,
        from: SentFrom.remote,
        status: SocketConnectionStatus.receiving,
        time: getFormattedTime(),
      );

      ref.read(allWebSocketMessagesProvider.notifier).state = [message, ...allMessages];
      yield allMessages;
    }
  }
});

class WebSocketNotifier extends StateNotifier<WebSocketChannel?> {
  // A StateNotifier to manage channel connection
  WebSocketNotifier(this._ref) : super(null);

  final Ref _ref;

  void connect(Uri uri) {
    state = WebSocketChannel.connect(uri);

    if (state != null) {
      _ref.invalidate(allWebSocketMessagesProvider);
      final allMessages = _ref.read(allWebSocketMessagesProvider);

      _ref.read(allWebSocketMessagesProvider.notifier).state = [
        WebSocketMessage(
          message: 'Connected successfully',
          from: SentFrom.remote,
          status: SocketConnectionStatus.connected,
          time: getFormattedTime(),
        ),
        ...allMessages ?? <WebSocketMessage>[],
      ];
    }
  }

  void send(String? data) {
    state?.sink.add(data);
  }

  void disconnect() async {
    await state?.sink.close();
    state = null;

    _ref.read(allWebSocketMessagesProvider.notifier).state = [
      WebSocketMessage(
        message: 'Disconnected',
        from: SentFrom.remote,
        status: SocketConnectionStatus.disconnected,
        time: getFormattedTime(),
      )
    ];
  }
}
