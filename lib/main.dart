import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  IO.Socket _socket;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _connectToServer() {
    try {
      IO.Socket socket = IO.io("http://192.168.0.102:3000/", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();

      _socket = socket;

      // TODO HANDLE SOCKET EVENTS

      socket.on('message', (data) {
        handleMessage(data);
      });
      socket.on('counterResponse', (data) {
        print(data);
      });
      socket.on('typing', handleTyping);

      socket.on('disconnect', (_) => print('disconnect'));
    } catch (e) {
      print(e);
    }
  }

  StreamSocket streamSocket = new StreamSocket();
  void handleTyping(Map<String, dynamic> data) {
    streamSocket.addResponse;
    print(data);
  }

  void handleMessage(Map<String, dynamic> data) {
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

  // Sends the current value of the counter via socket.io to the server
  void _emmitCounterValue() {
    try {
      _socket.emit('counter', _counter);
    } catch (e) {
      print("ERROR: $e");
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                sendMessage(messageController.value.text);
                messageController.clear();
              },
              child: Text(
                "Send Message",
              ),
            ),
            StreamBuilder(
              stream: streamSocket.getResponse,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Container(
                  child: Text("-${snapshot.data}"),
                );
              },
            ),
          ],
        ),
      ),

      // Added a second FAB. It calls the function to emit the counter's value
      // when pressed
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _emmitCounterValue,
            tooltip: 'Send',
            child: Icon(Icons.send),
          ),
        ],
      ),

      // Positioning the FAB
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
