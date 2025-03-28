import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/providers/auth_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../view_app/auth/screens/forgot_password/forgot_password.dart';
import '../../view_app/auth/screens/forgot_password/password_changed.dart';
import '../../view_app/auth/screens/introduction/introduction_screen.dart';
import '../../view_app/auth/screens/login/login_screen.dart';
import '../../view_app/auth/screens/signup/signup_screen.dart';
import '../../view_app/jarvis/screens/home/home_screen.dart';
import '../../view_app/jarvis/screens/profile/profile_screen.dart';
import '../../view_app/jarvis/screens/upgrade_plans/upgrade_plans_screen.dart';

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

// Khởi tạo GoRouter
final GoRouter router = GoRouter(
  navigatorKey: DialogHelper.navigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      redirect: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        // Nếu dữ liệu chưa load xong, chờ đợi
        if (authProvider.hasSeenIntro == null) {
          return null; // Không điều hướng ngay
        }

        return authProvider.hasSeenIntro ? AppRoutes.login : AppRoutes.intro;
      },
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
    final isAuthenticated = await authProvider.isAuthenticated();

    if (isAuthenticated) return AppRoutes.home;
    return AppRoutes.login;
  },
);
