import 'package:flutter/material.dart';
import '../features/home/home.dart';

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
    _buildComingSoonScreen('포스트'),
    _buildComingSoonScreen('좋아요'),
    _buildComingSoonScreen('프로필'),
  ];

  static Widget _buildComingSoonScreen(String feature) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '$feature 기능',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '추후 개발 예정',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
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
            setState(() => _index = i);
            widget.onIndexChanged?.call(i);
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 54,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 36),
              selectedIcon: Icon(Icons.home_rounded, size: 36),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search, size: 36),
              selectedIcon: Icon(Icons.search_rounded, size: 36),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.edit_outlined, size: 36),
              selectedIcon: Icon(Icons.edit_rounded, size: 36),
              label: 'Post',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_outlined, size: 36),
              selectedIcon: Icon(Icons.favorite_rounded, size: 36),
              label: 'Likes',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, size: 36),
              selectedIcon: Icon(Icons.person_rounded, size: 36),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
