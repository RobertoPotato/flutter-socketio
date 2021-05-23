import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_socket/controllers/chat_controller.dart';
import 'package:flutter_socket/screens/chats_screen.dart';
import 'package:get/get.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final notifications;

  const MyApp({Key key, this.notifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatsScreen(),
      initialBinding: BindingsBuilder(() => {
            Get.put(ChatController()),
          }),
    );
  }
}
