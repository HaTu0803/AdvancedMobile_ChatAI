import 'package:advancedmobile_chatai/core/helpers/dialog_helper.dart';
import 'package:advancedmobile_chatai/providers/auth_provider.dart';
import 'package:advancedmobile_chatai/view_app/auth/screens/forgot_password/forgot_password.dart';
import 'package:advancedmobile_chatai/view_app/auth/screens/forgot_password/password_changed.dart';
import 'package:advancedmobile_chatai/view_app/auth/screens/introduction/introduction_screen.dart';
import 'package:advancedmobile_chatai/view_app/auth/screens/login/login_screen.dart';
import 'package:advancedmobile_chatai/view_app/auth/screens/signup/signup_screen.dart';
import 'package:advancedmobile_chatai/view_app/jarvis/screens/chat_history/chat_history_screen.dart';
import 'package:advancedmobile_chatai/view_app/jarvis/screens/email_compose/email_compose_screen.dart';
import 'package:advancedmobile_chatai/view_app/jarvis/screens/profile/profile_screen.dart';
import 'package:advancedmobile_chatai/view_app/jarvis/screens/upgrade_plans/upgrade_plans_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:advancedmobile_chatai/main.dart';
import '../../view_app/jarvis/screens/home/home_screen.dart';
import '../../view_app/jarvis/screens/prompt_library/create_prompt/create_prompt_screen.dart';

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
  static const String history = '/conversation-history';
  static const String createPrompt = '/create-prompt';
  static const String bot = '/bot';
  static const String emailCompose = '/email-compose';
}

// Khởi tạo GoRouter
final GoRouter router = GoRouter(
    navigatorKey: DialogHelper.navigatorKey,
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
      GoRoute(
        path: AppRoutes.createPrompt,
        builder: (context, state) => const CreatePromptScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) {
          final assistantModel = state.extra as String? ?? 'dify';
          return ChatHistoryScreen(assistantModel: assistantModel);
        },
      ),
      GoRoute(
        path: AppRoutes.bot,
        builder: (context, state) {
          final assistantModel = state.extra as String? ?? 'dify';
          return ChatHistoryScreen(assistantModel: assistantModel);
        },
      ),
    ],
    redirect: (context, state) async {
      if ([AppRoutes.splash, AppRoutes.intro].contains(state.uri.path)) {
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      final hasSeenIntro = prefs.getBool('seenIntroduction') ?? false;

      if (!hasSeenIntro) {
        return AppRoutes.intro;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = await authProvider.isAuthenticated();

      if (isAuthenticated) return AppRoutes.home;

      if ([
        AppRoutes.signup,
        AppRoutes.forgotPassword,
        AppRoutes.passwordChanged,
      ].contains(state.uri.path)) {
        return null;
      }

      return AppRoutes.login;
    });
