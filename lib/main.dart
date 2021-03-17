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
      IO.Socket socket = IO.io("http://192.168.43.58:3000/", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      // Connect the socket
      socket.connect();

      //expose socket outside function
      _socket = socket;

      // Handle socket events
      socket.on('counterResponse', (data) {
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

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
    _connectToServer();
  }

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

      // Center the FAB
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
