import 'package:client_ao/src/modules/home/services/http_request.service.dart';
import 'package:client_ao/src/modules/home/states/collections.state.dart';
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
      ref.read(webSocketProvider.notifier).addMessage(message);
      yield allMessages;
    }
  }
});

class WebSocketNotifier extends StateNotifier<WebSocketChannel?> {
  // A StateNotifier to manage channel connection
  WebSocketNotifier(this._ref) : super(null);

  final Ref _ref;

  void connect(Uri? uri) {
    if (uri == null) return;

    state = WebSocketChannel.connect(uri);

    if (state != null) {
      _ref.invalidate(allWebSocketMessagesProvider);

      addMessage(WebSocketMessage(
        message: 'Connected successfully',
        from: SentFrom.remote,
        status: SocketConnectionStatus.connected,
        time: getFormattedTime(),
      ));
    }
  }

  void send(String? data) {
    state?.sink.add(data);
  }

  void addMessage(WebSocketMessage message) {
    final activeId = _ref.watch(activeIdProvider);
    final index = _ref.read(collectionsNotifierProvider.notifier).indexOfId();
    var collections = _ref.read(collectionsNotifierProvider);
    final requestResponse = _ref.read(collectionsNotifierProvider.notifier).getCollection()?.responses;
    var allMessages = _ref.read(responseStateProvider(activeId))?.value;

    allMessages = [message, ...allMessages ?? []];

    requestResponse?[activeId?.requestId ?? 0] = allMessages;
    collections[index] = collections[index].copyWith(responses: requestResponse);

    updateRequestResponseState(_ref, AsyncValue.data(allMessages), activeId?.requestId);
  }

  void disconnect() async {
    await state?.sink.close();
    state = null;

    addMessage(WebSocketMessage(
      message: 'Disconnected',
      from: SentFrom.remote,
      status: SocketConnectionStatus.disconnected,
      time: getFormattedTime(),
    ));
  }

  void clearResponses() {
    final activeId = _ref.read(activeIdProvider);
    updateRequestResponseState(_ref, const AsyncData([]), activeId?.requestId);
  }
}
