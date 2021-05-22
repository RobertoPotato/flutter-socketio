import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
  IO.Socket _socket;
  var _socketId;
  bool _isOnline = false;
  List<Map<String, dynamic>> _messages = [];
  ScrollController _scrollController = new ScrollController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _connectToServer() {
    try {
      IO.Socket socket = IO.io("http://192.168.0.102:3000/", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();

      _socket = socket;
      socket.onConnect((data) {
        print("CONNECTED TO SERVER - $data");
        setState(() {
          _isOnline = true;
          _socketId = socket.id;
        });
      });

      socket.onConnectError((data) {
        print("ERROR CONNECTING TO SERVER");
        setState(() {
          _isOnline = false;
        });
      });

      socket.onDisconnect((data) {
        print("DISCONNECTED FROM SERVER");
        _isOnline = false;
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

  //StreamSocket streamSocket = new StreamSocket();
  void handleTyping(Map<String, dynamic> data) {
    // streamSocket.addResponse;
    print(data);
  }

  void handleMessage(data) {
    // streamSocket.addResponse;
    setState(() {
      _messages.add(data);
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 70.0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Call function to attempt to connect to server
    _connectToServer();
  }

  TextEditingController messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(_messages.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: _isOnline ? Colors.black : Colors.redAccent,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _socketId == _messages[index]["id"]
                    ? Bubble(
                        nip: BubbleNip.rightBottom,
                        elevation: 2.0,
                        alignment: Alignment.bottomRight,
                        margin: BubbleEdges.only(top: 10, right: 10.0),
                        color: Color.fromRGBO(225, 255, 199, 1.0),
                        child: Text(
                          _messages[index]["message"],
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
                          _messages[index]["message"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      );
              },
              childCount: _messages == null ? 0 : _messages.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 80.0,
            ),
          ),
        ],
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
                  sendMessage(messageController.value.text);
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
