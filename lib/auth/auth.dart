// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../data/bloc/auth_bloc/auth_bloc.dart';
// import '../screens/login/login_screen.dart';
// import '../screens/signup/signup_screen.dart';
//
// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});
//
//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }
//
// class _AuthPageState extends State<AuthPage> {
//   bool a = true;
//   void go() {
//     setState(() {
//       a = !a;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (a) {
//       return BlocProvider(
//         create: (context) => AuthBloc(),
//         child: LoginScreen(show: go),
//       );
//     } else {
//       return BlocProvider(
//         create: (context) => AuthBloc(),
//         child: SignUPScreen(show: go),
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import '../screens/login/login_screen.dart';
import '../screens/signup/signup_screen.dart';

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
        ? LoginScreen(show: toggleScreen) // Thêm tham số show
        : SignUPScreen(show: toggleScreen);
  }
}
