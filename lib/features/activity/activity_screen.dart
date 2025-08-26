import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/sizes.dart';
import '../../constants/gaps.dart';
import '../../constants/text_style.dart';
import '../../constants/app_data.dart';
import '../../widgets/follow_btn.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ActivityItem> _allActivities = [];
  List<ActivityItem> _filteredActivities = [];

  static const _tabs = ['All', 'Replies', 'Mentions', 'Verified'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _allActivities = ActivityData.generateActivities();
    _filteredActivities = List.from(_allActivities);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          _filteredActivities = List.from(_allActivities);
          break;
        case 1:
          _filteredActivities = _allActivities
              .where((item) => item.type == ActivityType.reply)
              .toList();
          break;
        case 2:
          _filteredActivities = _allActivities
              .where((item) => item.type == ActivityType.mention)
              .toList();
          break;
        case 3:
          _filteredActivities = _allActivities
              .where((item) => item.type == ActivityType.follow)
              .toList();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ScreenHeader(),
            _CustomTabBar(tabController: _tabController, tabs: _tabs),
            Gaps.v20,
            _ActivityList(activities: _filteredActivities),
          ],
        ),
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.size16),
      child: Text('Activity', style: AppTextStyles.screenTitle),
    );
  }
}

class _CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;

  const _CustomTabBar({required this.tabController, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Sizes.size16),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = tabController.index == index;

            return GestureDetector(
              onTap: () => tabController.animateTo(index),
              child: Container(
                margin: EdgeInsets.only(
                  right: index < tabs.length - 1 ? Sizes.size8 : 0,
                ),
                width: Sizes.size96,
                height: Sizes.size40,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: Sizes.size1,
                  ),
                  borderRadius: BorderRadius.circular(Sizes.size10),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: isSelected
                        ? AppTextStyles.tabSelected
                        : AppTextStyles.tabUnselected,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  final List<ActivityItem> activities;

  const _ActivityList({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) =>
            _ActivityTile(activity: activities[index]),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Sizes.size16,
            vertical: Sizes.size8,
          ),
          leading: _ActivityAvatar(
            avatarUrl: activity.avatarUrl,
            activityType: activity.type,
          ),
          title: _ActivityTitle(
            username: activity.username,
            content: activity.content,
            timeAgo: activity.timeAgo,
          ),
          subtitle: activity.description.isNotEmpty
              ? _ActivitySubtitle(description: activity.description)
              : null,
          trailing: _ActivityTrailing(
            timeAgo: activity.timeAgo,
            isFollowActivity: activity.type == ActivityType.follow,
            username: activity.username,
          ),
        ),
        Divider(
          height: Sizes.size1,
          thickness: Sizes.size1,
          color: Colors.grey.shade200,
          indent: Sizes.size60, 
        ),
      ],
    );
  }
}

class _ActivityAvatar extends StatelessWidget {
  final String avatarUrl;
  final ActivityType activityType;

  const _ActivityAvatar({required this.avatarUrl, required this.activityType});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _ProfileImage(url: avatarUrl, size: Sizes.size44),
        _ActivityIcon(type: activityType),
      ],
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final String url;
  final double size;

  const _ProfileImage({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: Sizes.size2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Colors.white, size: size * 0.5),
          ),
        ),
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  final ActivityType type;

  const _ActivityIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -2,
      right: -2,
      child: Container(
        width: Sizes.size20,
        height: Sizes.size20,
        decoration: BoxDecoration(
          color: ActivityData.activityColors[type],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: Sizes.size2),
        ),
        child: Icon(
          ActivityData.activityIcons[type],
          color: Colors.white,
          size: Sizes.size12,
        ),
      ),
    );
  }
}

class _ActivityTitle extends StatelessWidget {
  final String username;
  final String content;
  final String timeAgo;

  const _ActivityTitle({
    required this.username,
    required this.content,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(username, style: AppTextStyles.username),
            Gaps.h8,
            Text(timeAgo, style: AppTextStyles.system),
          ],
        ),
        Gaps.v2,
        Text(content, style: AppTextStyles.activityContent),
      ],
    );
  }
}

class _ActivitySubtitle extends StatelessWidget {
  final String description;

  const _ActivitySubtitle({required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.size4),
      child: Text(description, style: AppTextStyles.commonText),
    );
  }
}

class _ActivityTrailing extends StatelessWidget {
  final String timeAgo;
  final bool isFollowActivity;
  final String username;

  const _ActivityTrailing({
    required this.timeAgo,
    required this.isFollowActivity,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isFollowActivity) ...[
          FollowButton(
            initialFollowState: true,
            onPressed: () {
              print('$username 언팔로우');
            },
          ),
        ],
      ],
    );
  }
}
