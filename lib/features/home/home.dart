import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../widgets/appbar.dart';
import '../../widgets/post_components.dart';
import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _isButtonVisible = _scrollController.offset > 200;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        'username': 'timferriss',
        'verified': true,
        'timeAgo': '7h',
        'text': 'Photoshoot with Molly pup. :)',
        'imageUrls': [
          'https://picsum.photos/id/237/1200/900',
          'https://picsum.photos/id/238/1200/900',
          'https://picsum.photos/id/239/1200/900',
        ],
        'replies': 53,
        'likes': 437,
        'likedByAvatars': [
          'https://i.pravatar.cc/100?img=3',
          'https://i.pravatar.cc/100?img=5',
        ],
      },
      {
        'username': 'chefmode',
        'verified': false,
        'timeAgo': '3h',
        'text': 'Soaked chickpeas ready for hummus ✨',
        'imageUrls': ['https://picsum.photos/id/1080/1200/900'],
        'replies': 23,
        'likes': 325,
        'likedByAvatars': [
          'https://i.pravatar.cc/100?img=8',
          'https://i.pravatar.cc/100?img=15',
          'https://i.pravatar.cc/100?img=20',
        ],
      },
      {
        'username': 'devmode',
        'verified': true,
        'timeAgo': '1h',
        'text':
            'Finally got my Flutter app working perfectly! The satisfaction is real 🚀',
        'imageUrls': [],
        'replies': 89,
        'likes': 1240,
        'likedByAvatars': [
          'https://i.pravatar.cc/100?img=12',
          'https://i.pravatar.cc/100?img=25',
        ],
      },
      {
        'username': 'designlover',
        'verified': false,
        'timeAgo': '45m',
        'text':
            'New UI design patterns are emerging. What do you think about glassmorphism?',
        'imageUrls': ['https://picsum.photos/id/180/1200/900'],
        'replies': 156,
        'likes': 892,
        'likedByAvatars': ['https://i.pravatar.cc/100?img=30'],
      },
    ].map((data) => PostModel.fromJson(data)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              const CustomAppBar(logoPath: 'assets/Threads-Logo.png'),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final postIndex = index ~/ 2;
                  if (index.isOdd) {
                    return Container(
                      height: Sizes.size1,
                      color: Colors.grey.shade200,
                      margin: EdgeInsets.symmetric(horizontal: Sizes.size16),
                    );
                  }

                  final post = posts[postIndex % posts.length];

                  return PostComponent(post: post);
                }, childCount: 15),
              ),
              SliverToBoxAdapter(child: Gaps.v32),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _isButtonVisible ? 15 : -60,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 45,
                width: 160,
                child: ElevatedButton(
                  onPressed: _isButtonVisible ? _scrollToTop : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Top'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
