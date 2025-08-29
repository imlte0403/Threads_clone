import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/appbar.dart';
import '../../widgets/post_components.dart';
import '../../models/post_model.dart';
import '../../constants/gaps.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scroll = ScrollController();
  bool _showTop = false;

  static const double _showThreshold = 200;
  static const double _hideThreshold = 120;

  @override
  void initState() {
    super.initState();

    _scroll.addListener(() {
      final y = _scroll.offset;

      if (!_showTop && y > _showThreshold) {
        setState(() => _showTop = true);
      } else if (_showTop && y < _hideThreshold) {
        setState(() => _showTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 커스텀 앱 바
              const CustomAppBar(logoPath: 'assets/Threads-Logo.png'),
              // firebase 데이터 연동
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (snap.hasError) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              Gaps.h16,
                              Text(
                                '불러오기 오류: ${snap.error}',
                                style: TextStyle(color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final docs = snap.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              Gaps.h16,
                              Text(
                                '아직 게시글이 없어요',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Gaps.h8,
                              Text(
                                '첫 번째 포스트를 작성해보세요!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final m = docs[index].data();
                      final createdAt = (m['createdAt'] as Timestamp?)
                          ?.toDate();

                      return PostComponent(
                        username: (m['username'] ?? 'user') as String,
                        timeAgo: formatTimeAgo(createdAt),
                        text: (m['text'] ?? (m['content'] ?? '')) as String,
                        replies: (m['replies'] ?? (m['comments'] ?? 0)) as int,
                        likes: (m['likes'] ?? 0) as int,
                        isVerified: (m['isVerified'] ?? false) as bool,
                        imageUrls:
                            (m['imageUrls'] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            const <String>[],
                        likedByAvatars:
                            (m['likedByAvatars'] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            const <String>[],
                        avatarUrl: (m['avatarUrl'] ?? '') as String,
                      );
                    }, childCount: docs.length),
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // TOP 버튼
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              bottom: false,
              child: Center(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(begin: 0.0, end: _showTop ? 1.0 : 0.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, -50 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            child: InkWell(
                              onTap: _scrollToTop,
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                height: 45,
                                width: 140,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_up_rounded,
                                      color: Colors.grey[700],
                                      size: 20,
                                    ),
                                    Gaps.v4,
                                    Text(
                                      'TOP',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
