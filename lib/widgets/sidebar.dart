import 'package:advancedmobile_chatai/core/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/util/themes/colors.dart';
import '../providers/auth_provider.dart';
import 'button.dart';
import 'dialog.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Text(
                      "J",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "JARVIS User",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Free Plan",
                          style: TextStyle(
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
                      context.go(AppRoutes.profile);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.workspace_premium,
                    title: "Upgrade Plans",
                    onTap: () {
                      context.go(AppRoutes.upgradePlans);
                    },
                  ),
                  const Divider(),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline,
                    title: "About",
                    onTap: () {},
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
                        context.go(AppRoutes.login); // Điều hướng về trang đăng nhập
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
