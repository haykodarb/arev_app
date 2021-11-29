import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketBackend {
  late WebSocketChannel webSocket;

  Stream<dynamic> createWebSocketStream({
    required String ipAddress,
  }) {
    final String webSocketURI = 'ws://$ipAddress:81';
    webSocket = WebSocketChannel.connect(
      Uri.parse(
        webSocketURI,
      ),
    );
    return webSocket.stream;
  }

  void closeWebSocketStream() {
    webSocket.sink.close();
  }
}
