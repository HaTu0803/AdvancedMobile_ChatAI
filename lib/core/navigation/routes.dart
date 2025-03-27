import 'package:advancedmobile_chatai/main.dart';
import 'package:advancedmobile_chatai/providers/auth_provider.dart';
import 'package:advancedmobile_chatai/view_app/auth/forgot_password/forgot_password.dart';
import 'package:advancedmobile_chatai/view_app/auth/forgot_password/password_changed.dart';
import 'package:advancedmobile_chatai/view_app/auth/login/login_screen.dart';
import 'package:advancedmobile_chatai/view_app/auth/screens/home/home_screen.dart';
import 'package:advancedmobile_chatai/view_app/auth/screens/introduction/introduction_screen.dart';
import 'package:advancedmobile_chatai/view_app/auth/signup/signup_screen.dart';
import 'package:advancedmobile_chatai/view_app/screens/profile/profile_screen.dart';
import 'package:advancedmobile_chatai/view_app/screens/upgrade_plans/upgrade_plans_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String intro = '/introduction';
  static const String passwordChanged = '/password-changed';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';
  static const String upgradePlans = '/upgrade-plans';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Khởi tạo GoRouter
final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey, // ✅ Thêm navigatorKey vào đây

  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.intro,
      builder: (context, state) => const IntroductionScreen(),
    ),
    GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen()),
    GoRoute(
        path: AppRoutes.upgradePlans,
        builder: (context, state) => const UpgradePlansScreen()),
    GoRoute(
        path: AppRoutes.passwordChanged,
        builder: (context, state) => const PasswordChanged()),
    GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPassword()),
  ],
  redirect: (context, state) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final seenIntro = await authProvider.hasSeenIntro();
    final isAuthenticated = await authProvider.isAuthenticated();

    if (!seenIntro) return AppRoutes.intro;
    if (isAuthenticated) return AppRoutes.home;
    return AppRoutes.login;
  },
);
