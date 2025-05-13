import 'dart:async';

import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/core/navigation/routes.dart';
import 'package:advancedmobile_chatai/core/util/themes/theme.dart';
import 'package:advancedmobile_chatai/providers/auth_provider.dart';
import 'package:advancedmobile_chatai/providers/prompt_input.dart';
import 'package:advancedmobile_chatai/providers/prompt_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => PromptProvider()),
            ChangeNotifierProvider(create: (context) => AuthProvider()),
            ChangeNotifierProvider(
              create: (context) => PromptInputProvider(),
            ),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint("🔥 Global Error: $error");
      DialogHelper.showError("Lỗi hệ thống: $error");
    },
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

  Future<String> _determineStartScreen(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadHasSeenIntro();
    final isAuthenticated = await authProvider.isAuthenticated();

    if (isAuthenticated) {
      return AppRoutes.home;
    } else {
      return authProvider.hasSeenIntro ? AppRoutes.login : AppRoutes.intro;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _determineStartScreen(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(snapshot.data!);
          });
          return const SizedBox.shrink();
        } else {
          return const Scaffold(
            body: Center(child: Text("Lỗi tải ứng dụng!")),
          );
        }
      },
    );
  }
}