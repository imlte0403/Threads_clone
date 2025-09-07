import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/sizes.dart';
import '../constants/app_colors.dart';

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
          Icon(
            Icons.language,
            size: Sizes.size28,
            color: AppColors.label(context),
          ),

          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: Sizes.size28,
                  color: AppColors.label(context),
                ),
              ),
              SizedBox(width: Sizes.size16),

              GestureDetector(
                onTap: () {
                  context.go('/settings');
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
