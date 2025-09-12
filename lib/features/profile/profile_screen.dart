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
            child: ProfileHeader(profile: ProfileDataProvider.demoProfile),
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
                itemCount: ProfileDataProvider.demoThreadsData.length,
                itemBuilder: (_, i) {
                  final profilePost = ProfileDataProvider.demoThreadsData[i];
                  return PostComponent(
                    post: profilePost.toPostModel(),
                  );
                },
              ),
              ListView.builder(
                padding: EdgeInsets.zero, 
                itemCount: ProfileDataProvider.demoRepliesData.length,
                itemBuilder: (_, i) {
                  final profilePost = ProfileDataProvider.demoRepliesData[i];
                  return PostComponent(
                    post: profilePost.toPostModel(),
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
