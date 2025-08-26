import 'package:flutter/material.dart';
import '../../constants/sizes.dart';
import '../../constants/gaps.dart';
import '../../constants/text_style.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        title: Text(
          "Privacy",
          style: AppTextStyles.screenTitle.copyWith(fontSize: Sizes.size20),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300, // 연회색 divider
            height: 1.0,
          ),
        ),
      ),

      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: _isPrivate,
            onChanged: (v) => setState(() => _isPrivate = v),
            title: const Text("Private profile", style: AppTextStyles.settings),
            activeColor: Colors.white,
            activeTrackColor: Colors.black,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
          ),

          ListTile(
            leading: const Icon(Icons.alternate_email, color: Colors.black),
            title: const Text("Mentions"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Everyone",
                  style: TextStyle(color: Colors.grey, fontSize: Sizes.size14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.volume_off, color: Colors.black),
            title: const Text("Muted"),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.visibility_off, color: Colors.black),
            title: const Text("Hidden Words"),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.group, color: Colors.black),
            title: const Text("Profiles you follow"),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),

          Container(color: Colors.grey.shade200, height: Sizes.size1),

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
                    children: const [
                      Text(
                        "Other privacy settings",
                        style: AppTextStyles.sectionTitle,
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
                child: const Icon(Icons.open_in_new, color: Colors.grey),
              ),
            ],
          ),

          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.black),
            title: const Text("Blocked profiles"),
            trailing: const Icon(Icons.open_in_new, color: Colors.grey),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.favorite_border, color: Colors.black),
            title: const Text("Hide likes"),
            trailing: const Icon(Icons.open_in_new, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
