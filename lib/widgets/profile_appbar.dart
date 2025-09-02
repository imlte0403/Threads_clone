import 'package:flutter/material.dart';
import '../constants/sizes.dart';
import '../constants/app_colors.dart';
import '../features/settings/settings_screen.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: true,
      backgroundColor: AppColors.systemBackground(context),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.language, size: Sizes.size28, color: AppColors.label(context)),

          Row(
            children: [
              GestureDetector(
                onTap: () => print('Instagram icon pressed'),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: Sizes.size28,
                  color: AppColors.label(context),
                ),
              ),
              SizedBox(width: Sizes.size16),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(), // 이동할 화면
                    ),
                  );
                },
                child: Icon(
                  Icons.menu,
                  size: Sizes.size28,
                  color: AppColors.label(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
