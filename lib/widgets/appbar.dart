import 'package:flutter/material.dart';
import '../constants/sizes.dart';
import '../constants/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String logoPath = Theme.of(context).brightness == Brightness.dark
        ? 'assets/Threads-Logo-white.png'
        : 'assets/Threads-Logo.png';

    return SliverAppBar(
      pinned: false,
      floating: true,
      backgroundColor: AppColors.systemBackground(context),
      elevation: 0,
      centerTitle: true,
      title: Image.asset(logoPath, height: Sizes.size32),
    );
  }
}
