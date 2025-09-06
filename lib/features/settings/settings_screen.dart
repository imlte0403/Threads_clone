// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thread_clone/constants/gaps.dart';
import '../../constants/sizes.dart';
import '../../constants/text_style.dart';
import '../../constants/app_colors.dart';
import 'settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: AppTextStyles.screenTitle(
            context,
          ).copyWith(fontSize: Sizes.size20),
        ),
        centerTitle: true,
        backgroundColor: AppColors.systemBackground(context),
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => context.go('/profile'),
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back_ios, color: AppColors.label(context)),
                Gaps.h2,
                Text(
                  'Back',
                  style: TextStyle(
                    color: AppColors.label(context),
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
          child: Container(color: AppColors.separator(context), height: 1.0),
        ),
      ),
      body: ListView(
        children: [
          Consumer<SettingsViewModel>(
            builder: (context, settingsViewModel, child) {
              return SwitchListTile(
                secondary: Icon(
                  Icons.dark_mode,
                  color: AppColors.label(context),
                ),
                title: Text(
                  "Dark mode",
                  style: AppTextStyles.settings(context),
                ),
                value: settingsViewModel.darkMode,
                onChanged: (value) {
                  settingsViewModel.setDarkMode(value);
                },
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person_add_alt,
              color: AppColors.label(context),
            ),
            title: Text(
              "Follow and invite friends",
              style: AppTextStyles.settings(context),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.notifications_none,
              color: AppColors.label(context),
            ),
            title: Text(
              "Notifications",
              style: AppTextStyles.settings(context),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.lock_outline, color: AppColors.label(context)),
            title: Text("Privacy", style: AppTextStyles.settings(context)),
            onTap: () {
              context.go('/settings/privacy');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle_outlined,
              color: AppColors.label(context),
            ),
            title: Text("Account", style: AppTextStyles.settings(context)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: AppColors.label(context)),
            title: Text("Help", style: AppTextStyles.settings(context)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.label(context)),
            title: Text("About", style: AppTextStyles.settings(context)),
            onTap: () {},
          ),
          const Divider(height: Sizes.size2, thickness: 0.5),
          ListTile(
            title: Text("Log out", style: AppTextStyles.logout),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
