import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  IO.Socket _socket;
  var socketId;
  bool isOnline = false;
  List<Map<String, dynamic>> messages = [];
  ScrollController scrollController = new ScrollController();

  void connectToServer() {
    try {
      IO.Socket socket = IO.io("http://192.168.0.102:3000/", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();

      _socket = socket;
      socket.onConnect((data) {
        print("CONNECTED TO SERVER - $data");
        isOnline = true;
        update();
        socketId = socket.id;
        update();
      });

      socket.onConnectError((data) {
        print("ERROR CONNECTING TO SERVER");
        isOnline = false;
        update();
      });

      socket.onDisconnect((data) {
        print("DISCONNECTED FROM SERVER");
        isOnline = false;
      });

      // TODO HANDLE SOCKET EVENTS
      socket.on('message', (data) {
        handleMessage(data);
      });

      socket.on('typing', handleTyping);

      socket.on('disconnect', (_) => print('disconnect'));
    } catch (e) {
      print(e);
    }
  }

  void handleTyping(Map<String, dynamic> data) {
    // streamSocket.addResponse;
    print(data);
  }

  void handleMessage(data) {
    // streamSocket.addResponse;
    messages.add(data);
    update();
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 70.0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    update();
    print(data);
  }

  sendTyping(bool typing) {
    _socket.emit("typing", {
      "id": _socket.id,
      "typing": typing,
    });
  }

  sendMessage(String message) {
    _socket.emit(
      "message",
      {
        "id": _socket.id,
        "message": message, // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
