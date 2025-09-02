import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../features/create_post/create_post_screen.dart';
import '../constants/sizes.dart';
import '../constants/app_colors.dart';

class AppNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final Function(int)? onIndexChanged;

  const AppNavBar({super.key, required this.navigationShell, this.onIndexChanged});

  int _getSelectedIndex() {
    // Map branch index to UI index
    final branchIndex = navigationShell.currentIndex;
    if (branchIndex < 2) {
      return branchIndex; // 0,1 → 0,1 (home, search)
    } else {
      return branchIndex + 1; // 2,3 → 3,4 (activity, profile)
    }
  }

  void _onTap(BuildContext context, int index) {
    if (index == 2) {
      // Show create post modal
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: CreatePostScreen(
            avatarUrl:
                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
          ),
        ),
      );
    } else {
      // Map UI index to branch index
      int branchIndex;
      if (index < 2) {
        branchIndex = index; // 0,1 → 0,1 (home, search)
      } else {
        branchIndex = index - 1; // 3,4 → 2,3 (activity, profile)
      }
      navigationShell.goBranch(branchIndex);
      onIndexChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.systemBackground(context),
          indicatorColor: Colors.transparent,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? AppColors.label(context)
                  : AppColors.quaternaryLabel(context),
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _getSelectedIndex(),
          onDestinationSelected: (index) => _onTap(context, index),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: Sizes.size56,
          destinations: const [
            NavigationDestination(
              icon: Icon(CupertinoIcons.home, size: Sizes.size32),
              selectedIcon: Icon(CupertinoIcons.house_fill, size: Sizes.size32),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.search, size: Sizes.size32),
              selectedIcon: Icon(CupertinoIcons.search, size: Sizes.size32),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.plus_square, size: Sizes.size32),
              selectedIcon: Icon(
                CupertinoIcons.plus_square_fill,
                size: Sizes.size32,
              ),
              label: 'Post',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.heart, size: Sizes.size32),
              selectedIcon: Icon(CupertinoIcons.heart_fill, size: Sizes.size32),
              label: 'Likes',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.person, size: Sizes.size32),
              selectedIcon: Icon(
                CupertinoIcons.person_fill,
                size: Sizes.size32,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
