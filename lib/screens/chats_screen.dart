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
    print("CHAT SCREEN USER NAME = ${chatController.user.toString()}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${chatController.user}"),
          backgroundColor: Colors.black,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "${chatController.isOnline ? "Online" : "Offline"}",
                  style: TextStyle(
                    color: chatController.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: GetBuilder<ChatController>(
          builder: (GetxController controller) {
            //TODO Compare users to see if their id matches current user. If so, don't show their chats here
            return ListView.builder(
              itemCount: chatController.users == null
                  ? 0
                  : chatController.users.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(chatController.users[index]["userName"]),
                  onTap: () {
                    Get.to(
                      () => MessagingScreen(
                        title: chatController.users[index]["userName"],
                        socket: chatController.users[index]["userName"],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
