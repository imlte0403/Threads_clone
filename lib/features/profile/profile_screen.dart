import 'package:flutter/material.dart';
import 'profile_model.dart';
import 'profile_content.dart';
import '../../widgets/profile_appbar.dart';
import '../../widgets/post_components.dart';
import '../../constants/gaps.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<String> _tabs = ['Threads', 'Replies'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ProfilePostModel> _getCurrentTabData() {
    switch (_tabController.index) {
      case 0:
        return ProfileData.threadsData;
      case 1:
        return ProfileData.repliesData;
      default:
        return ProfileData.threadsData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const ProfileAppBar(),

          SliverToBoxAdapter(
            child: ProfileHeader(profile: ProfileData.janeProfile),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [Gaps.v16, const ProfileActionButtons(), Gaps.v16],
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: ProfileTabBarDelegate(
              tabController: _tabController,
              tabs: _tabs,
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final posts = _getCurrentTabData();
              if (index >= posts.length) return null;

              final post = posts[index];
              return PostComponent(
                username: post.username,
                timeAgo: post.timeAgo,
                text: post.text,
                replies: post.replies,
                likes: post.likes,
                imageUrls: post.imageUrls,
                likedByAvatars: post.likedByAvatars,
                isVerified: post.isVerified,
                avatarUrl: post.avatarUrl,
              );
            }, childCount: _getCurrentTabData().length),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
