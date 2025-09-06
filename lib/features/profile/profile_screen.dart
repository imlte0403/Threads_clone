import 'package:flutter/material.dart';
import 'profile_model.dart';
import 'profile_content.dart';
import '../../widgets/profile_appbar.dart';
import '../../widgets/post_components.dart';
import '../../constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
    static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Threads', 'Replies'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.systemBackground(context),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerScrolled) => [
          const ProfileAppBar(),
          SliverToBoxAdapter(
            child: ProfileHeader(profile: ProfileData.janeProfile),
          ),
          SliverToBoxAdapter(child: const ProfileActionButtons()),
          SliverPersistentHeader(
            pinned: true,
            delegate: ProfileTabBarDelegate(
              tabController: _tabController,
              tabs: _tabs,
            ),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.only(top: 0), 
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                padding: EdgeInsets.zero, 
                itemCount: ProfileData.threadsData.length,
                itemBuilder: (_, i) {
                  final post = ProfileData.threadsData[i];
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
                },
              ),
              ListView.builder(
                padding: EdgeInsets.zero, 
                itemCount: ProfileData.repliesData.length,
                itemBuilder: (_, i) {
                  final post = ProfileData.repliesData[i];
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
