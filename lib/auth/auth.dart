import 'package:flutter/material.dart';

import '../view_app/screens/auth/login/login_screen.dart';
import '../view_app/screens/auth/signup/signup_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  void toggleScreen() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginScreen(show: toggleScreen)
        : SignUpScreen(show: toggleScreen);
  }
}
