import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_model.dart';
import '../../constants/sizes.dart';
import '../../constants/gaps.dart';
import '../../constants/text_style.dart';
import '../../constants/app_colors.dart';

class AvatarNetwork extends StatelessWidget {
  const AvatarNetwork({super.key, required this.size, this.url});
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
            child: Icon(Icons.person, color: AppColors.systemBackground(context), size: size * 0.6),
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
            color: const Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: AppColors.systemBackground(context), size: size * 0.6),
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.size16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 유저네임
                Text(
                  profile.username,
                  style: AppTextStyles.username(context).copyWith(fontSize: 20),
                ),
                // 아이디
                Row(
                  children: [
                    Text(profile.userId, style: AppTextStyles.commonText(context)),
                    Gaps.h8,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size12,
                        vertical: Sizes.size6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondarySystemBackground(context),
                        borderRadius: BorderRadius.circular(Sizes.size16),
                      ),
                      child: Text(
                        'threads.net',
                        style: AppTextStyles.system(context).copyWith(
                          color: AppColors.tertiaryLabel(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.v8,
                // 소개글
                Text(profile.bio, style: AppTextStyles.commonText(context)),
                Gaps.v10,
                Row(
                  children: [
                    // 겹친 아바타 스택
                    SizedBox(
                      width: 32,
                      height: 16,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: AvatarNetwork(
                              size: 16,
                              url:
                                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
                            ),
                          ),
                          Positioned(
                            left: 12,
                            child: AvatarNetwork(
                              size: 16,
                              url:
                                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '2 followers',
                      style: AppTextStyles.system(context).copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AvatarNetwork(size: Sizes.size60, url: profile.avatarUrl),
        ],
      ),
    );
  }
}

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.size20),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              text: 'Edit profile',
              onPressed: () {
                // TODO:  프로필 편집 기능 구현
              },
            ),
          ),
          Gaps.h8,
          Expanded(
            child: _ActionButton(
              text: 'Share profile',
              onPressed: () {
                // TODO:  프로필 공유 기능 구현
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _ActionButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.size40,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.separator(context), width: Sizes.size1),
        borderRadius: BorderRadius.circular(Sizes.size10),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
        ),
        child: Text(text, style: AppTextStyles.followingButton(context)),
      ),
    );
  }
}

class ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<String> tabs;

  ProfileTabBarDelegate({required this.tabController, required this.tabs});

  @override
  double get minExtent => Sizes.size48;

  @override
  double get maxExtent => Sizes.size48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: AppColors.systemBackground(context),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: AnimatedBuilder(
          animation: tabController,
          builder: (_, __) {
            return Row(
              children: List.generate(tabs.length, (i) {
                final isSelected = tabController.index == i;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => tabController.animateTo(
                      i,
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                    ),
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? AppColors.label(context)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tabs[i],
                        style: isSelected
                            ? AppTextStyles.username(context)
                            : AppTextStyles.commonText(context).copyWith(
                                color: AppColors.tertiaryLabel(context),
                              ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ProfileTabBarDelegate old) => true;
}
