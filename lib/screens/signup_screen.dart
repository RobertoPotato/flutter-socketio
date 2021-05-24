import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_socket/controllers/chat_controller.dart';
import 'package:flutter_socket/screens/chats_screen.dart';
import 'package:get/get.dart';

const users = const {
  'a@b.c': 'aaaa',
  'b@c.d': 'bbbb',
};

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ChatController chatController;

  Duration get loginTime => Duration(milliseconds: 1000);

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User does not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      chatController.setUser(email: data.name);
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController = Get.find<ChatController>();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onSignup: _authUser,
      onLogin: _authUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        Get.to(ChatsScreen());
      },
    );
  }
}
