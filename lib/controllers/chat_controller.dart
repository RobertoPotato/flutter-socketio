import 'package:flutter/material.dart';
import 'package:flutter_socket/models/message_model.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Process:
/// 1. Connection is created
/// 2. User Joins server => join
/// 3. User receives list of users in server
/// 4. User can send and receive messages etc

class ChatController extends GetxController {
  IO.Socket _socket;
  var socketId;
  var user;
  bool isOnline = false;
  List<MessageModel> messages = [];
  List users = [];
  ScrollController scrollController = new ScrollController();

  void setUser({@required String email}) {
    user = email;
    update();
  }

  void connectToServer() {
    try {
      IO.Socket socket = IO.io("http://192.168.0.102:3000/", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();
      isOnline = true;
      update();

      _socket = socket;
      socket.onConnect((data) {
        print("CONNECTED TO SERVER");
        socketId = socket.id;
        update();
        _socket.emit(
          "join",
          user,
        );
        isOnline = true;
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
        update();
      });

      // TODO HANDLE SOCKET EVENTS
      socket.on('message', (data) {
        handleMessage(data);
      });

      socket.on('userList', (data) {
        handleUsersList(data);
      });

      socket.on('typing', handleTyping);

      // socket.on('disconnect', (_) => print('disconnect'));
    } catch (e) {
      print(e);
    }
  }

  void handleUsersList(data) {
    users.add(data[0]);
    update();
    print("ALL USERS = ${users.toString()}");
  }

  void handleTyping(Map<String, dynamic> data) {
    // streamSocket.addResponse;
    print(data);
  }

  void handleMessage(data) {
    var msg = new MessageModel.fromJson(data);
    messages.add(msg);
    update();
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 70.0,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void sendTyping(bool typing) {
    _socket.emit("typing", {
      "id": _socket.id,
      "typing": typing,
    });
  }

  void sendMessage({@required String message, @required String receiver}) {
    MessageModel newMessage = new MessageModel(
      receiver: receiver,
      date: DateTime.now().millisecondsSinceEpoch,
      sender: _socket.id,
      content: message,
    );

    messages.add(newMessage);
    update();

    _socket.emit(
      "message",
      {newMessage.toJson()},
    );
  }
}
