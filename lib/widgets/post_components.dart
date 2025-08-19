import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/text_style.dart';
import '../constants/sizes.dart';
import '../constants/gaps.dart';

class PostComponent extends StatefulWidget {
  const PostComponent({
    super.key,
    // 필수 요소
    required this.username,
    required this.timeAgo,
    required this.text,
    required this.replies,
    required this.likes,

    // 이미지/아바타/인증 배지
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
  State<PostComponent> createState() => _PostComponentState();
}

class _AvatarNetwork extends StatelessWidget {
  const _AvatarNetwork({required this.size, this.url});
  final double size;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final u = url?.trim();
    if (u == null || u.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: Container(
            color: const Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Colors.white, size: size * 0.6),
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
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Colors.white, size: size * 0.6),
          ),
        ),
      ),
    );
  }
}

class _PostComponentState extends State<PostComponent> {
  bool isLiked = false;
  bool isCommented = false;
  bool isReposted = false;
  bool isShared = false;

  @override
  Widget build(BuildContext context) {
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
              // 유저 프로필/세로라인/미니 아바타
              Column(
                children: [
                  _AvatarNetwork(size: Sizes.size36, url: widget.avatarUrl),
                  Gaps.v8,
                  Expanded(
                    child: Container(
                      width: Sizes.size2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.grey.shade300, Colors.grey.shade100],
                        ),
                      ),
                    ),
                  ),
                  Gaps.v8,
                  _MiniAvatarStack(urls: widget.likedByAvatars),
                ],
              ),
              Gaps.h12,

              // 본문
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(widget.username, style: AppTextStyles.username),
                        if (widget.isVerified) ...[
                          Gaps.h4,
                          const Icon(
                            Icons.verified,
                            size: Sizes.size16,
                            color: Colors.blue,
                          ),
                        ],
                        const Spacer(),
                        Text(widget.timeAgo, style: AppTextStyles.system),
                        Gaps.h12,
                        Icon(
                          Icons.more_horiz,
                          size: Sizes.size18,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    Gaps.v4,
                    Text(widget.text, style: AppTextStyles.postText),

                    if (widget.imageUrls.isNotEmpty) ...[
                      Gaps.v12,
                      _MediaGallery(urls: widget.imageUrls),
                    ],

                    Gaps.v16,
                    Row(
                      children: [
                        _ActionIcon(
                          icon: isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          onTap: () => setState(() => isLiked = !isLiked),
                          isSelected: isLiked,
                          selectedColor: Colors.pink,
                        ),
                        Gaps.h20,
                        _ActionIcon(
                          icon: Icons.mode_comment_outlined,
                          onTap: () =>
                              setState(() => isCommented = !isCommented),
                          isSelected: isCommented,
                          selectedColor: Colors.amber,
                        ),
                        Gaps.h20,
                        _ActionIcon(
                          icon: Icons.repeat,
                          onTap: () => setState(() => isReposted = !isReposted),
                          isSelected: isReposted,
                          selectedColor: Colors.green,
                        ),
                        Gaps.h20,
                        _ActionIcon(
                          icon: Icons.send_outlined,
                          onTap: () => setState(() => isShared = !isShared),
                          isSelected: isShared,
                          selectedColor: Colors.blue,
                        ),
                      ],
                    ),
                    Gaps.v12,
                    Text(
                      '${widget.replies} replies · ${widget.likes} likes',
                      style: AppTextStyles.system,
                    ),
                  ],
                ),
              ),
            ],
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
    this.selectedColor = Colors.blue,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Sizes.size8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? selectedColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: Sizes.size20,
          color: isSelected ? selectedColor : Colors.grey.shade700,
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
                  border: Border.all(color: Colors.white, width: Sizes.size2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: urls[i],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 1),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.person,
                        size: Sizes.size12,
                        color: Colors.grey.shade600,
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
    // 최대 3장 제한
    final display = urls.take(3).toList();
    if (display.isEmpty) return const SizedBox.shrink();

    final screenW = MediaQuery.of(context).size.width;
    final baseWidth =
        screenW - (Sizes.size16 * 2) - Sizes.size36 - Sizes.size12;

    // 이미지 개수에 따른 레이아웃 조정
    return _buildImageLayout(display, baseWidth);
  }

  Widget _buildImageLayout(List<String> images, double maxWidth) {
    if (images.length == 1) {
      return _buildSingleImage(images[0], maxWidth);
    } else if (images.length == 2) {
      return _buildTwoImages(images, maxWidth);
    } else {
      return _buildThreeImages(images, maxWidth);
    }
  }

  // 단일 이미지 레이아웃
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

  // 2장 이미지 레이아웃 (완전히 왼쪽 정렬 + 다음 이미지 미리보기)
  Widget _buildTwoImages(List<String> images, double maxWidth) {
    return SizedBox(
      height: Sizes.size200,
      width: maxWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            width: maxWidth * 0.95,
            margin: EdgeInsets.only(right: index < images.length - 1 ? 8 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.size12),
              child: _buildCachedImage(images[index]),
            ),
          );
        },
      ),
    );
  }

  // 3장 이미지 레이아웃
  Widget _buildThreeImages(List<String> images, double maxWidth) {
    return SizedBox(
      height: Sizes.size200,
      width: maxWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            width: maxWidth * 0.9,
            margin: EdgeInsets.only(right: index < images.length - 1 ? 8 : 0),
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
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: Sizes.size32,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 4),
              Text(
                '이미지 로드 실패',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
