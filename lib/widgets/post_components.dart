import 'package:flutter/material.dart';
import '../constants/text_style.dart';
import '../constants/sizes.dart';
import '../constants/gaps.dart';

class PostComponent extends StatelessWidget {
  const PostComponent({
    super.key,
    required this.username,
    this.isVerified = false,
    required this.timeAgo,
    required this.text,
    this.imageUrls = const [],
    required this.replies,
    required this.likes,
    this.likedByAvatars = const [],
  });

  final String username;
  final bool isVerified;
  final String timeAgo;
  final String text;
  final List<String> imageUrls;
  final int replies;
  final int likes;
  final List<String> likedByAvatars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.size16,
        vertical: Sizes.size12,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const _Avatar(size: Sizes.size36),
                Gaps.v8,
                Expanded(
                  child: Container(
                    width: Sizes.size2,
                    color: Colors.grey.shade300,
                  ),
                ),
                Gaps.v8,
                _MiniAvatarStack(urls: likedByAvatars),
              ],
            ),
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(username, style: AppTextStyles.username),
                      if (isVerified) ...[
                        Gaps.h4,
                        Icon(
                          Icons.verified,
                          size: Sizes.size16,
                          color: Colors.blue,
                        ),
                      ],
                      const Spacer(),
                      Text(timeAgo, style: AppTextStyles.system),
                      Gaps.h12,
                      Icon(
                        Icons.more_horiz,
                        size: Sizes.size18,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                  Gaps.v4,
                  Text(text, style: AppTextStyles.postText),
                  // 이미지가 있을 때
                  if (imageUrls.isNotEmpty) ...[
                    Gaps.v12,
                    _MediaImage(url: imageUrls.first),
                  ],
                  Gaps.v16,
                  Row(
                    children: [
                      _ActionIcon(icon: Icons.favorite_border, onTap: () {}),
                      Gaps.h20,
                      _ActionIcon(
                        icon: Icons.mode_comment_outlined,
                        onTap: () {},
                      ),
                      Gaps.h20,
                      _ActionIcon(icon: Icons.repeat, onTap: () {}),
                      Gaps.h20,
                      _ActionIcon(icon: Icons.send_outlined, onTap: () {}),
                    ],
                  ),
                  Gaps.v12,
                  Text(
                    '$replies replies · $likes likes',
                    style: AppTextStyles.system,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 내부 위젯들
class _Avatar extends StatelessWidget {
  const _Avatar({this.size = Sizes.size36});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.lightBlue.shade100,
      ),
      child: Icon(Icons.person, color: Colors.white, size: size * 0.6),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Sizes.size8),
        child: Icon(icon, size: Sizes.size20, color: Colors.grey.shade700),
      ),
    );
  }
}

class _MiniAvatarStack extends StatelessWidget {
  const _MiniAvatarStack({required this.urls});
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty)
      return const SizedBox(width: Sizes.size24, height: Sizes.size24);

    final displayCount = urls.length.clamp(0, 3);

    return SizedBox(
      width:
          Sizes.size24 +
          (displayCount > 1 ? (displayCount - 1) * Sizes.size12 : 0),
      height: Sizes.size24,
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * Sizes.size12,
              child: Container(
                width: Sizes.size24,
                height: Sizes.size24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: Sizes.size2),
                ),
                child: ClipOval(
                  child: Image.network(
                    urls[i],
                    width: Sizes.size20,
                    height: Sizes.size20,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
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

class _MediaImage extends StatelessWidget {
  const _MediaImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Sizes.size12),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: Sizes.size200),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: Sizes.size150,
            color: Colors.grey.shade200,
            child: Center(
              child: Icon(
                Icons.broken_image,
                size: Sizes.size48,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: Sizes.size150,
              color: Colors.grey.shade100,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: Sizes.size2,
                  color: Colors.grey.shade400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
