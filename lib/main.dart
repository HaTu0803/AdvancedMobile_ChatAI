import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/auth.dart';
import 'package:advancedmobile_chatai/screens/introduction/introduction_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkIntroSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenIntroduction') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkIntroSeen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Hiển thị loading khi chờ dữ liệu
          }
          return snapshot.data == true ? const AuthPage() : const IntroductionScreen();
        },
      ),
    );
  }
}
