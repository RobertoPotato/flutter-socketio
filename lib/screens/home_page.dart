import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket/controllers/chat_controller.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ChatController chatController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Call function to attempt to connect to server
    chatController = Get.put(ChatController());
    chatController.connectToServer();
  }

  TextEditingController messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(chatController.messages.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor:
            chatController.isOnline ? Colors.black : Colors.redAccent,
      ),
      body: GetBuilder<ChatController>(
        builder: (_) {
          return CustomScrollView(
            controller: chatController.scrollController,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return chatController.socketId ==
                            chatController.messages[index]["id"]
                        ? Bubble(
                            nip: BubbleNip.rightBottom,
                            elevation: 2.0,
                            alignment: Alignment.bottomRight,
                            margin: BubbleEdges.only(top: 10, right: 10.0),
                            color: Color.fromRGBO(225, 255, 199, 1.0),
                            child: Text(
                              chatController.messages[index]["message"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          )
                        :

                        // If this user is not the sender show this
                        Bubble(
                            nip: BubbleNip.leftBottom,
                            elevation: 2.0,
                            alignment: Alignment.bottomLeft,
                            margin: BubbleEdges.only(top: 10, left: 10.0),
                            child: Text(
                              chatController.messages[index]["message"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          );
                  },
                  childCount: chatController.messages == null
                      ? 0
                      : chatController.messages.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100.0,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 12,
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type a message',
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  chatController.sendMessage(messageController.value.text);
                  messageController.clear();
                },
                child: Icon(
                  Icons.send_rounded,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
