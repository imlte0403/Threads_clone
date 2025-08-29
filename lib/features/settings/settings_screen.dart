// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:thread_clone/constants/gaps.dart';
import '../../constants/sizes.dart';
import '../../constants/text_style.dart';
import 'privacy_screen.dart'; 

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: AppTextStyles.screenTitle.copyWith(fontSize: Sizes.size20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_ios, color: Colors.black),
                Gaps.h2,
                const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_add_alt, color: Colors.black),
            title: const Text(
              "Follow and invite friends",
              style: AppTextStyles.settings,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none, color: Colors.black),
            title: const Text("Notifications", style: AppTextStyles.settings),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline, color: Colors.black),
            title: const Text("Privacy", style: AppTextStyles.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle_outlined,
              color: Colors.black,
            ),
            title: const Text("Account", style: AppTextStyles.settings),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.black),
            title: const Text("Help", style: AppTextStyles.settings),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.black),
            title: const Text("About", style: AppTextStyles.settings),
            onTap: () {},
          ),
          const Divider(height: Sizes.size2, thickness: 0.5),
          ListTile(
            title: const Text("Log out", style: AppTextStyles.logout),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
