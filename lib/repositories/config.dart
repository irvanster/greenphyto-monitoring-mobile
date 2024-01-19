import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String baseUrl = "https://greenphytotest.genieedocs.com/";

class SocketManager {
  late IO.Socket socket;

  SocketManager() {
    initSocket();
  }

  void initSocket() {
    socket = IO.io(baseUrl, <String, dynamic>{
      'autoConnect': true,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      if (kDebugMode) {
        print('Connection established');
      }
    });
    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }
}
