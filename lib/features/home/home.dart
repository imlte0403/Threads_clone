import 'package:flutter/material.dart';
import '../../widgets/appbar.dart';
import '../../widgets/post_components.dart';
import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        'username': 'timferriss',
        'verified': true,
        'timeAgo': '7h',
        'text': 'Photoshoot with Molly pup. :)',
        'imageUrls': ['https://picsum.photos/id/237/1200/900'],
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
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
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

              return PostComponent(
                username: post['username'] as String,
                isVerified: post['verified'] as bool,
                timeAgo: post['timeAgo'] as String,
                text: post['text'] as String,
                imageUrls: (post['imageUrls'] as List<dynamic>).cast<String>(),
                replies: post['replies'] as int,
                likes: post['likes'] as int,
                likedByAvatars: (post['likedByAvatars'] as List<dynamic>)
                    .cast<String>(),
              );
            }, childCount: 15),
          ),
          SliverToBoxAdapter(child: Gaps.v32),
        ],
      ),
    );
  }
}
