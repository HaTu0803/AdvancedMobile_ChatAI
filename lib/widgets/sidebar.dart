// lib/widgets/sidebar.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/my_profile/my_profile.dart';
import '../screens/chat_history/chat_history.dart';
import '../screens/upgrade_plans/upgrade_plans.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40.r,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'JARVIS',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // My Profile
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              'My Profile',
              style: TextStyle(fontSize: 16.sp),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProfileScreen()),
              );
            },
          ),
          // Chat History
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'Chat History',
              style: TextStyle(fontSize: 16.sp),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatHistoryScreen()),
              );
            },
          ),
          // Upgrade Plans
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: Text(
              'Upgrade Plans',
              style: TextStyle(fontSize: 16.sp),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpgradePlansScreen()),
              );
            },
          ),
          const Divider(),
          // Log out
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Log out',
              style: TextStyle(fontSize: 16.sp),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Log out'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Close drawer
                        // Add your logout logic here
                      },
                      child: const Text('Log out'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          // App version
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}