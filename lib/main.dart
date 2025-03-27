import 'package:advancedmobile_chatai/core/navigation/routes.dart';
import 'package:advancedmobile_chatai/core/util/themes/theme.dart';
import 'package:advancedmobile_chatai/providers/auth_provider.dart';
import 'package:advancedmobile_chatai/view_app/auth/login/login_screen.dart';
import 'package:advancedmobile_chatai/view_app/auth/screens/home/home_screen.dart';
import 'package:advancedmobile_chatai/view_app/auth/screens/introduction/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: router,
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<Widget> _determineStartScreen(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final isAuthenticated = await authProvider.isAuthenticated();
    final seenIntro = await authProvider.hasSeenIntro();

    if (isAuthenticated) {
      return const HomeScreen(); // Nếu đã đăng nhập, vào trang chính
    } else {
      return seenIntro
          ? const LoginScreen()
          : const IntroductionScreen(); // Nếu chưa đăng nhập, vào trang giới thiệu
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _determineStartScreen(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const Scaffold(
            body: Center(child: Text("Lỗi tải ứng dụng!")),
          );
        }
      },
    );
  }
}
