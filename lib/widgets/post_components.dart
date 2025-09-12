import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thread_clone/widgets/post_modalBottomSheet.dart';
import '../constants/text_style.dart';
import '../constants/sizes.dart';
import '../constants/gaps.dart';
import '../constants/app_colors.dart';
import '../models/post_model.dart';

class PostComponent extends ConsumerStatefulWidget {
  const PostComponent({
    super.key,
    required this.post,
    this.onLike,
    this.onUnlike,
    this.onDelete,
    this.showInteractions = true,
  });

  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onUnlike;
  final VoidCallback? onDelete;
  final bool showInteractions;

  @override
  ConsumerState<PostComponent> createState() => _PostComponentState();
}

class LegacyPostComponent extends StatelessWidget {
  const LegacyPostComponent({
    super.key,
    required this.username,
    required this.timeAgo,
    required this.text,
    required this.replies,
    required this.likes,
    this.imageUrls = const <String>[],
    this.likedByAvatars = const <String>[],
    this.isVerified = false,
    this.avatarUrl,
  });

  final String username;
  final String timeAgo;
  final String text;
  final int replies;
  final int likes;
  final List<String> imageUrls;
  final List<String> likedByAvatars;
  final bool isVerified;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final post = PostModel(
      username: username,
      text: text,
      avatarUrl: avatarUrl,
      isVerified: isVerified,
      imageUrls: imageUrls,
      replies: replies,
      likes: likes,
      likedByAvatars: likedByAvatars,
      createdAt: _parseTimeAgo(timeAgo),
    );

    return PostComponent(post: post);
  }

  DateTime? _parseTimeAgo(String timeAgo) {
    final now = DateTime.now();
    if (timeAgo.endsWith('h')) {
      final hours = int.tryParse(timeAgo.replaceAll('h', '')) ?? 0;
      return now.subtract(Duration(hours: hours));
    } else if (timeAgo.endsWith('m')) {
      final minutes = int.tryParse(timeAgo.replaceAll('m', '')) ?? 0;
      return now.subtract(Duration(minutes: minutes));
    } else if (timeAgo.endsWith('d')) {
      final days = int.tryParse(timeAgo.replaceAll('d', '')) ?? 0;
      return now.subtract(Duration(days: days));
    }
    return now;
  }
}

class _PostComponentState extends ConsumerState<PostComponent> {
  bool isLiked = false;
  bool isCommented = false;
  bool isReposted = false;
  bool isShared = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.size8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size16,
          vertical: Sizes.size12,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 좌측 섹션
              Column(
                children: [
                  // 프로필 이미지
                  _AvatarNetwork(
                    size: Sizes.size36,
                    url: post.avatarUrl,
                    isAnonymous: post.isAnonymous,
                  ),
                  Gaps.v8,
                  // 세로선
                  Expanded(
                    child: Container(
                      width: Sizes.size2,
                      color: AppColors.separator(context),
                    ),
                  ),
                  Gaps.v8,
                  // 아바타 이미지
                  _MiniAvatarStack(urls: post.likedByAvatars),
                ],
              ),
              Gaps.h12,
              Expanded(
                // 우측 섹션
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v4,
                    // 유저 네임 / 인증 마크 / 시간 / ... 버튼
                    Row(
                      children: [
                        // 유저 네임 (익명 처리)
                        Text(
                          post.isAnonymous ? 'anonymous' : post.username,
                          style: AppTextStyles.username(context).copyWith(
                            color: post.isAnonymous 
                                ? AppColors.tertiaryLabel(context)
                                : AppColors.label(context),
                          ),
                        ),
                        // 인증 마크
                        if (post.isVerified && !post.isAnonymous) ...[
                          Gaps.h4,
                          Icon(
                            Icons.verified,
                            size: Sizes.size16,
                            color: AppColors.accent(context),
                          ),
                        ],
                        const Spacer(),
                        // 시간
                        Text(
                          post.timeAgo,
                          style: AppTextStyles.system(context),
                        ),
                        Gaps.h12,
                        // ... 버튼
                        _buildMoreButton(post),
                      ],
                    ),
                    Gaps.v4,
                    Text(post.text, style: AppTextStyles.commonText(context)),
                    if (post.hasImages) ...[
                      Gaps.v12,
                      _MediaGallery(urls: post.imageUrls),
                    ],
                    if (widget.showInteractions) ...[
                      Gaps.v16,
                      _buildInteractionRow(),
                      Gaps.v12,
                      Text(
                        '${post.replies} replies · ${post.likes} likes',
                        style: AppTextStyles.system(context),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreButton(PostModel post) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: AppColors.systemBackground(context),
          context: context,
          builder: (context) => PostModalBottomSheet(
            canDelete: post.isAnonymous, // 익명 게시물만 삭제 가능
            onDelete: widget.onDelete,
          ),
        );
      },
      child: Icon(
        Icons.more_horiz,
        size: Sizes.size18,
        color: AppColors.tertiaryLabel(context),
      ),
    );
  }

  Widget _buildInteractionRow() {
    return Row(
      children: [
        _ActionIcon(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          onTap: () {
            setState(() => isLiked = !isLiked);
            if (isLiked) {
              widget.onLike?.call();
            } else {
              widget.onUnlike?.call();
            }
          },
          isSelected: isLiked,
          selectedColor: Colors.red,
        ),
        Gaps.h5,
        _ActionIcon(
          icon: Icons.mode_comment_outlined,
          onTap: () => setState(() => isCommented = !isCommented),
          isSelected: isCommented,
          selectedColor: Colors.orange,
        ),
        Gaps.h5,
        _ActionIcon(
          icon: Icons.repeat,
          onTap: () => setState(() => isReposted = !isReposted),
          isSelected: isReposted,
          selectedColor: Colors.green,
        ),
        Gaps.h5,
        _ActionIcon(
          icon: Icons.send_outlined,
          onTap: () => setState(() => isShared = !isShared),
          isSelected: isShared,
        ),
      ],
    );
  }
}


class _AvatarNetwork extends StatelessWidget {
  const _AvatarNetwork({
    required this.size, 
    this.url,
    this.isAnonymous = false,
  });
  final double size;
  final String? url;
  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    final u = url?.trim();
    
    // 익명 아바타 표시
    if (isAnonymous || u == null || u.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: Container(
            color: isAnonymous 
                ? AppColors.tertiaryLabel(context).withOpacity(0.1)
                : AppColors.secondarySystemBackground(context),
            child: Icon(
              isAnonymous ? Icons.person_outline : Icons.person,
              color: isAnonymous 
                  ? AppColors.tertiaryLabel(context)
                  : AppColors.systemBackground(context),
              size: size * 0.6,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: u,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.secondarySystemBackground(context),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.secondarySystemBackground(context),
            child: Icon(
              Icons.person,
              color: AppColors.systemBackground(context),
              size: size * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}


class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    this.selectedColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? AppColors.accent(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Sizes.size8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size20),
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: Sizes.size20,
          color: isSelected ? color : AppColors.secondaryLabel(context),
        ),
      ),
    );
  }
}

class _MiniAvatarStack extends StatelessWidget {
  const _MiniAvatarStack({required this.urls});
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return const SizedBox(width: Sizes.size24, height: Sizes.size24);
    }
    final n = urls.length.clamp(0, 3);
    return SizedBox(
      width: Sizes.size24 + (n > 1 ? (n - 1) * Sizes.size12 : 0),
      height: Sizes.size24,
      child: Stack(
        children: [
          for (int i = 0; i < n; i++)
            Positioned(
              left: i * Sizes.size12,
              child: Container(
                width: Sizes.size24,
                height: Sizes.size24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.systemBackground(context),
                    width: Sizes.size2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.label(context).withValues(alpha: 0.1),
                      blurRadius: Sizes.size4,
                      offset: const Offset(0, Sizes.size1),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: urls[i],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.secondarySystemBackground(context),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: Sizes.size1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MediaGallery extends StatelessWidget {
  const _MediaGallery({required this.urls});
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    final display = urls.take(3).toList();
    if (display.isEmpty) return const SizedBox.shrink();

    final screenW = MediaQuery.of(context).size.width;
    final baseWidth =
        screenW - (Sizes.size16 * 2) - Sizes.size36 - Sizes.size12;

    return _buildImageLayout(display, baseWidth);
  }

  Widget _buildImageLayout(List<String> images, double maxWidth) {
    if (images.length == 1) {
      return _buildSingleImage(images[0], maxWidth);
    } else {
      return _buildMultipleImages(images, maxWidth);
    }
  }

  Widget _buildSingleImage(String imageUrl, double maxWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Sizes.size12),
      child: SizedBox(
        width: maxWidth,
        height: Sizes.size200,
        child: _buildCachedImage(imageUrl),
      ),
    );
  }

  Widget _buildMultipleImages(List<String> images, double maxWidth) {
    return SizedBox(
      height: Sizes.size200,
      width: maxWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            width: maxWidth * 0.9,
            margin: EdgeInsets.only(
              right: index < images.length - 1 ? Sizes.size8 : 0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.size12),
              child: _buildCachedImage(images[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCachedImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.secondarySystemBackground(context),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.secondarySystemBackground(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: Sizes.size32,
                color: AppColors.quaternaryLabel(context),
              ),
              Gaps.v4,
              Text(
                '이미지 로드 실패',
                style: TextStyle(
                  fontSize: Sizes.size12,
                  color: AppColors.tertiaryLabel(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
