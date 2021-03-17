import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
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
      // Socket Configuration
      //TODO Change URL
      IO.Socket socket = IO.io("http://192.168.43.58:3000/", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Connect the socket
      socket.connect();

      //expose socket outside function
      _socket = socket;

      // TODO HANDLE SOCKET EVENTS
      // Server responds to emitted counter value it receives by broadcasting it
      // To all connected sockets. This method catches that response and prints
      // the data received from it

      socket.on('counterResponse', (data) {
        print(data);
      });

      // ... More Events ...
    } catch (e) {
      print(e);
    }
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

  // The rest of this is the startup counter app with some minor changes
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
