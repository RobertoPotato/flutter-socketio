import 'dart:async';

import 'package:flutter/material.dart';

import 'home_page.dart';

Future<void> main() async {
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
  final notifications;

  const MyApp({Key key, this.notifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Chat Demo',
      ),
    );
  }
}
