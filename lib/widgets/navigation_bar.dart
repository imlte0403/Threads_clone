import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../features/home/home.dart';
import '../features/create_post/create_post_screen.dart';
import '../features/search/search_screen.dart';
import '../features/activity/activity_screen.dart';
import '../features/profile/profile_screen.dart';
import '../constants/sizes.dart';
import '../constants/app_colors.dart';

class AppNavBar extends StatefulWidget {
  final Function(int)? onIndexChanged;

  const AppNavBar({super.key, this.onIndexChanged});

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  int _index = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    CreatePostScreen(
      avatarUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
    ),
    const ActivityScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
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
          selectedIndex: _index,
          onDestinationSelected: (i) {
            if (i == 2) {
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
              setState(() => _index = i);
              widget.onIndexChanged?.call(i);
            }
          },
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
