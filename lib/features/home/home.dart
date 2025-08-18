import 'package:flutter/material.dart';
import '../../widgets/navigation_bar.dart';
import '../../widgets/appbar.dart';
import '../../constants/text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(logoPath: 'assets/Threads-Logo.png'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => PostCardStub(index: index),
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class PostCardStub extends StatelessWidget {
  final int index;
  const PostCardStub({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),

                // username
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Taeeun', style: AppTextStyles.username),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 본문 텍스트
                const Text(
                  'This is a stub post. Replace me with real content.',
                  style: AppTextStyles.postText,
                ),
                const SizedBox(height: 8),

                // 시스템 텍스트
                const Text(
                  '23 comments   403 likes',
                  style: AppTextStyles.system,
                ),
                const SizedBox(height: 8),

                // ImagePagerStub(height: 200),  // 필요 시
              ],
            ),
          ),
        ],
      ),
    );
  }
}
