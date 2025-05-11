import 'package:advancedmobile_chatai/core/navigation/routes.dart';
import 'package:advancedmobile_chatai/view_app/knowledge_base/screens/knowledge/knowledge_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/util/themes/colors.dart';
import '../data_app/model/jarvis/subscription_model.dart';
import '../data_app/model/jarvis/user_model.dart';
import '../data_app/repository/jarvis/subscription_repository.dart';
import '../data_app/repository/jarvis/user_repository.dart';
import '../providers/auth_provider.dart';
import '../view_app/jarvis/screens/email_compose/email_compose_screen.dart';
import '../view_app/jarvis/screens/profile/profile_screen.dart';
import '../view_app/jarvis/screens/upgrade_plans/upgrade_plans_screen.dart';
import '../view_app/knowledge_base/screens/knowledge/bot.dart';
import 'button.dart';
import 'dialog.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final TokenRepository _userRepository = TokenRepository();
  final SubscriptionRepository _subscriptionRepository = SubscriptionRepository();
  CurrentUserReponse? _currentUser;
  UsageResponse? _subscription;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      debugPrint("🔄 Loading user data...");
      
      // Get user data
      final userData = await _userRepository.getCurrentUser();
      debugPrint("✅ User data loaded: ${userData.toJson()}");
      
      // Get subscription data
      final subscriptionData = await _subscriptionRepository.getUsage();
      debugPrint("✅ Subscription data loaded: ${subscriptionData.toJson()}");
      
      if (mounted) {
        setState(() {
          _currentUser = userData;
          _subscription = subscriptionData;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ Error loading user data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: SafeArea(
        child: Column(
          children: [
            // User Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.5),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red),
                              const SizedBox(height: 8),
                              Text(
                                'Error loading data',
                                style: TextStyle(color: Colors.red[700]),
                              ),
                              TextButton(
                                onPressed: _loadUserData,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                _currentUser?.username.substring(0, 1).toUpperCase() ?? "U",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentUser?.username ?? "Unknown User",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _subscription?.name ?? "Free Plan",
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: "My Profile",
                    onTap: () {
                      Navigator.pop(context); // Close the sidebar
                      _showProfileScreen(
                          context); // Show Profile Screen in bottom sheet
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.workspace_premium,
                    title: "Upgrade Plans",
                    onTap: () {
                      _showUpgradePlansScreen(
                          context); // Show Upgrade Plans Screen in bottom sheet
                    },
                  ),
                  const Divider(),
                  _buildMenuItem(
                    context,
                    icon: Icons.smart_toy_outlined,
                    title: "Bot",
                    onTap: () {
                      _showBotScreen(
                          context); // Show Bot Screen in bottom sheet
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.email_outlined,
                    title: "Compose Email",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmailComposeScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.storage,
                    title: "Data",
                    onTap: () {
                      _showDataScreen(
                          context); // Show Data Screen in bottom sheet
                    },
                  ),
                  const Divider(),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    onTap: () {
                      _showSettingsScreen(
                          context); // Show Settings Screen in bottom sheet
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {
                      _showHelpSupportScreen(
                          context); // Show Help & Support Screen in bottom sheet
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline,
                    title: "About",
                    onTap: () {
                      _showAboutScreen(
                          context); // Show About Screen in bottom sheet
                    },
                  ),
                ],
              ),
            ),

            // Logout Button
            Container(
              padding: const EdgeInsets.all(16),
              child: logOutButton(
                onPressed: () {
                  showCustomDialog(
                    context: context,
                    title: "Log Out",
                    message: "Are you sure you want to log out?",
                    onConfirm: () async {
                      try {
                        await authProvider.logOut(); // Gọi hàm đăng xuất
                        if (!context.mounted) return;
                        context.go(
                            AppRoutes.login); // Điều hướng về trang đăng nhập
                      } catch (e) {
                        debugPrint("Logout failed: $e");
                      }
                    },
                    isConfirmation: true,
                    confirmText: "Log Out",
                    cancelText: "Cancel",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const ProfileScreen();
      },
    );
  }

  void _showUpgradePlansScreen(BuildContext context) async {
    final Uri url = Uri.parse('https://dev.jarvis.cx/pricing');
    try {
      if (!await launchUrl(url)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch upgrade plans')),
          );
        }
      } else {
        // After successful URL launch, reload user data to check for subscription changes
        if (context.mounted) {
          await _loadUserData();
          if (_subscription?.name == "Pro Plan") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully upgraded to Pro Plan!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  // This function shows the Bot screen as a modal bottom sheet
  void _showBotScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const BotsScreen();
        },
      ),
    );
  }

  // This function shows the Data screen as a modal bottom sheet
  void _showDataScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const KnowledgeBaseScreen();
        },
      ),
    );
  }

  // This function shows the Settings screen as a modal bottom sheet
  void _showSettingsScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const Center(
          child: Text("Settings"), // Replace with your Settings widget
        );
      },
    );
  }

  // This function shows the Help & Support screen as a modal bottom sheet
  void _showHelpSupportScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const Center(
          child:
              Text("Help & Support"), // Replace with your Help & Support widget
        );
      },
    );
  }

  // This function shows the About screen as a modal bottom sheet
  void _showAboutScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const Center(
          child: Text("About"), // Replace with your About widget
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

Widget logOutButton({required VoidCallback onPressed}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15.w),
    child: TCustomButton(
      text: 'Log Out',
      onPressed: onPressed,
      type: ButtonType.filled,
      customStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.primary),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 16.h)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        )),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50.h)),
        alignment: Alignment.center,
      ),
    ),
  );
}
