import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/appbar.dart';
import '../../widgets/post_components.dart';
import '../../constants/gaps.dart';
import '../../constants/app_colors.dart';
import '../../constants/sizes.dart';
import 'home_view_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scroll = ScrollController();
  bool _showTop = false;

  static const double _showThreshold = 200;
  static const double _hideThreshold = 120;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scroll.addListener(() {
      final y = _scroll.offset;

      // TOP 버튼 표시 로직
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

  void _onPostLike(String postId) {
    ref.read(homeViewModelProvider.notifier).likePost(postId);
  }

  void _onPostUnlike(String postId) {
    ref.read(homeViewModelProvider.notifier).unlikePost(postId);
  }

  void _onPostDelete(String postId) {
    ref.read(homeViewModelProvider.notifier).deletePost(postId);
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsStreamProvider);

    ref.listen(homeViewModelProvider, (previous, current) {
      if (current.hasError && current.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(current.errorMessage!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '확인',
              textColor: Colors.white,
              onPressed: () {
                ref.read(homeViewModelProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.systemBackground(context),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scroll,
            physics: const BouncingScrollPhysics(),
            slivers: [
              const CustomAppBar(),
              postsAsync.when(
                loading: () => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.size32),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.accent(context),
                        ),
                      ),
                    ),
                  ),
                ),
                error: (error, stackTrace) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.size32),
                    child: Center(
                      child: Text(
                        '오류가 발생했습니다: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                data: (posts) {
                  if (posts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.size48),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: Sizes.size64,
                                color: AppColors.quaternaryLabel(context),
                              ),
                              Gaps.v16,
                              Text(
                                '아직 게시글이 없어요',
                                style: TextStyle(
                                  fontSize: Sizes.size18,
                                  color: AppColors.tertiaryLabel(context),
                                ),
                              ),
                              Gaps.v8,
                              Text(
                                '첫 번째 포스트를 작성해보세요!',
                                style: TextStyle(
                                  fontSize: Sizes.size14,
                                  color: AppColors.tertiaryLabel(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = posts[index];
                        return PostComponent(
                          post: post,
                          onLike: post.id != null ? () => _onPostLike(post.id!) : null,
                          onUnlike: post.id != null ? () => _onPostUnlike(post.id!) : null,
                          onDelete: post.id != null ? () => _onPostDelete(post.id!) : null,
                        );
                      },
                      childCount: posts.length,
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          _buildTopButton(),
        ],
      ),
    );
  }

  Widget _buildTopButton() {
    return Positioned(
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
                    margin: const EdgeInsets.only(top: Sizes.size12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.size25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.label(context).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: AppColors.systemBackground(context),
                      borderRadius: BorderRadius.circular(Sizes.size25),
                      child: InkWell(
                        onTap: _scrollToTop,
                        borderRadius: BorderRadius.circular(Sizes.size25),
                        child: Container(
                          height: 45,
                          width: 140,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: AppColors.secondaryLabel(context),
                                size: Sizes.size20,
                              ),
                              Gaps.h4,
                              Text(
                                'TOP',
                                style: TextStyle(
                                  color: AppColors.secondaryLabel(context),
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size14,
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
    );
  }
}