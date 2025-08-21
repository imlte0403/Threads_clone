import 'package:flutter/material.dart';
import '../features/home/home.dart';
import '../features/create_post/create_post_screen.dart';
import '../constants/sizes.dart';
import '../constants/gaps.dart';

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
    _buildComingSoonScreen('검색'),
    CreatePostScreen(
      avatarUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
    ),
    _buildComingSoonScreen('좋아요'),
    _buildComingSoonScreen('프로필'),
  ];

  static Widget _buildComingSoonScreen(String feature) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_outlined,
            size: Sizes.size64,
            color: Colors.grey[400],
          ),
          Gaps.v16,
          Text(
            '$feature 기능',
            style: TextStyle(
              fontSize: Sizes.size24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Gaps.v8,
          Text(
            '추후 개발 예정',
            style: TextStyle(fontSize: Sizes.size16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? Colors.black
                  : Colors.grey[400],
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
              icon: Icon(Icons.home_outlined, size: Sizes.size36),
              selectedIcon: Icon(Icons.home_rounded, size: Sizes.size36),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search, size: Sizes.size36),
              selectedIcon: Icon(Icons.search_rounded, size: Sizes.size36),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.edit_outlined, size: Sizes.size36),
              selectedIcon: Icon(Icons.edit_rounded, size: Sizes.size36),
              label: 'Post',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_outlined, size: Sizes.size36),
              selectedIcon: Icon(Icons.favorite_rounded, size: Sizes.size36),
              label: 'Likes',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, size: Sizes.size36),
              selectedIcon: Icon(Icons.person_rounded, size: Sizes.size36),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
