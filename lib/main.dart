import 'package:advancedmobile_chatai/util/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Adjust this based on your design
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: FutureBuilder<bool>(
            future: checkIntroSeen(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return snapshot.data == true ? const AuthPage() : const IntroductionScreen();
            },
          ),
        );
      },
    );
  }
}
