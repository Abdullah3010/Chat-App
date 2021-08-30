import 'package:chat/modules/login/login_screen.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  static String routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LoginScreen(),
    );
  }
}
