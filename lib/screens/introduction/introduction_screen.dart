import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth.dart';


class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  Future<void> _completeIntroduction(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenIntroduction', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Chào mừng đến với ứng dụng!", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _completeIntroduction(context),
              child: const Text("Bắt đầu"),
            ),
          ],
        ),
      ),
    );
  }
}
