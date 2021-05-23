import 'package:flutter/material.dart';
import 'package:flutter_socket/controllers/chat_controller.dart';
import 'package:flutter_socket/screens/messaging_screen.dart';
import 'package:get/get.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  ChatController chatController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController = Get.find<ChatController>();
    chatController.connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ListTile(
              leading: Material(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("MD"),
                ),
              ),
              title: Text("Mr Doe"),
              onTap: () {
                Get.to(() => MessagingScreen(title: "Mr Doe"));
              },
            )
          ],
        ),
      ),
    );
  }
}
