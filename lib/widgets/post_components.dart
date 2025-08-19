import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../constants/text_style.dart';
import '../constants/sizes.dart';
import '../constants/gaps.dart';

class PostComponent extends StatefulWidget {
  const PostComponent({super.key, required this.post});

  final PostModel post;

  @override
  State<PostComponent> createState() => _PostComponentState();
}

class _PostComponentState extends State<PostComponent> {
  bool isLiked = false;
  bool isCommented = false;
  bool isReposted = false;
  bool isShared = false;

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
                _MiniAvatarStack(urls: widget.post.likedByAvatars),
              ],
            ),
            Gaps.h12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.post.username, style: AppTextStyles.username),
                      if (widget.post.isVerified) ...[
                        Gaps.h4,
                        Icon(
                          Icons.verified,
                          size: Sizes.size16,
                          color: Colors.blue,
                        ),
                      ],
                      const Spacer(),
                      Text(widget.post.timeAgo, style: AppTextStyles.system),
                      Gaps.h12,
                      Icon(
                        Icons.more_horiz,
                        size: Sizes.size18,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                  Gaps.v4,
                  Text(widget.post.text, style: AppTextStyles.postText),
                  if (widget.post.imageUrls.isNotEmpty) ...[
                    Gaps.v12,
                    _MediaGallery(urls: widget.post.imageUrls),
                  ],
                  Gaps.v16,
                  Row(
                    children: [
                      _ActionIcon(
                        icon: isLiked ? Icons.favorite : Icons.favorite_border,
                        onTap: () => setState(() => isLiked = !isLiked),
                        isSelected: isLiked,
                        selectedColor: Colors.pink,
                      ),
                      Gaps.h20,
                      _ActionIcon(
                        icon: Icons.mode_comment_outlined,
                        onTap: () => setState(() => isCommented = !isCommented),
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
                    '${widget.post.replies} replies · ${widget.post.likes} likes',
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
        padding: EdgeInsets.all(Sizes.size8),
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

class _MediaGallery extends StatelessWidget {
  const _MediaGallery({required this.urls});
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayUrls = urls.take(3).toList();
    final screenWidth = MediaQuery.of(context).size.width;
    // Paddings (16*2) + Avatar(36) + Gap(12)
    final galleryWidth =
        screenWidth - (Sizes.size16 * 2) - Sizes.size36 - Sizes.size12;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(displayUrls.length, (index) {
          return Container(
            margin: EdgeInsets.only(
              right: index < displayUrls.length - 1 ? Sizes.size8 : 0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.size12),
              child: SizedBox(
                width: galleryWidth,
                height: Sizes.size200,
                child: Image.network(
                  displayUrls[index],
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
            ),
          );
        }),
      ),
    );
  }
}
