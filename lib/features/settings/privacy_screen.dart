import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/sizes.dart';
import '../../constants/gaps.dart';
import '../../constants/text_style.dart';
import '../../constants/app_colors.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.systemBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.systemBackground(context),
        elevation: 0,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => context.go('/settings'),
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
        title: Text(
          "Privacy",
          style: AppTextStyles.screenTitle(context).copyWith(fontSize: Sizes.size20),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.separator(context),
            height: 1.0,
          ),
        ),
      ),

      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: _isPrivate,
            onChanged: (v) => setState(() => _isPrivate = v),
            title: Text("Private profile", style: AppTextStyles.settings(context)),
            activeColor: AppColors.systemBackground(context),
            activeTrackColor: AppColors.label(context),
            inactiveThumbColor: AppColors.systemBackground(context),
            inactiveTrackColor: AppColors.quaternaryLabel(context),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
          ),

          ListTile(
            leading: Icon(Icons.alternate_email, color: AppColors.label(context)),
            title: const Text("Mentions"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(
                  builder: (context) => Text(
                    "Everyone",
                    style: TextStyle(color: AppColors.tertiaryLabel(context), fontSize: Sizes.size14),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, color: AppColors.tertiaryLabel(context)),
              ],
            ),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.volume_off, color: AppColors.label(context)),
            title: const Text("Muted"),
            trailing: Icon(Icons.chevron_right, color: AppColors.tertiaryLabel(context)),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.visibility_off, color: AppColors.label(context)),
            title: const Text("Hidden Words"),
            trailing: Icon(Icons.chevron_right, color: AppColors.tertiaryLabel(context)),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.group, color: AppColors.label(context)),
            title: const Text("Profiles you follow"),
            trailing: Icon(Icons.chevron_right, color: AppColors.tertiaryLabel(context)),
            onTap: () {},
          ),

          Container(color: AppColors.separator(context), height: Sizes.size1),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size16,
                    vertical: Sizes.size12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Other privacy settings",
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      Gaps.v8,
                      Text(
                        "Some settings, like restrict, apply to both \nThreads and Instagram and can be managed \non Instagram.",
                        style: AppTextStyles.description,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: Sizes.size24,
                  top: Sizes.size16,
                ),
                child: Icon(Icons.open_in_new, color: AppColors.tertiaryLabel(context)),
              ),
            ],
          ),

          ListTile(
            leading: Icon(Icons.cancel, color: AppColors.label(context)),
            title: const Text("Blocked profiles"),
            trailing: Icon(Icons.open_in_new, color: AppColors.tertiaryLabel(context)),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.favorite_border, color: AppColors.label(context)),
            title: const Text("Hide likes"),
            trailing: Icon(Icons.open_in_new, color: AppColors.tertiaryLabel(context)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
