import 'package:flutter/material.dart';

// 프로필 이미지
const profileImages = [
  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1494790108755-2616b612b5bc?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1463453091185-61582044d556?w=100&h=100&fit=crop&crop=face',
  'https://images.unsplash.com/photo-1502767089025-6572583495b0?w=100&h=100&fit=crop&crop=face',
];

class UserProfile {
  final String username;
  final String displayName;
  final String followers;
  final bool isVerified;
  final String avatarUrl;

  UserProfile({
    required this.username,
    required this.displayName,
    required this.followers,
    required this.isVerified,
    required this.avatarUrl,
  });
}

class SearchData {
  // 검색 화면 사용자 데이터
  static const usersData = [
    {'username': 'rjmithun', 'displayName': 'Mithun', 'followers': '26.6K'},
    {'username': 'vicenews', 'displayName': 'VICE News', 'followers': '301K'},
    {
      'username': 'trevornoah',
      'displayName': 'Trevor Noah',
      'followers': '789K',
    },
    {
      'username': 'condenasttraveller',
      'displayName': 'Condé Nast Traveller',
      'followers': '130K',
    },
    {
      'username': 'chef_pillai',
      'displayName': 'Suresh Pillai',
      'followers': '69.2K',
    },
    {
      'username': 'malala',
      'displayName': 'Malala Yousafzai',
      'followers': '237K',
    },
    {
      'username': 'sebin_cyriac',
      'displayName': 'Fishing_freaks',
      'followers': '53.2K',
    },
  ];

  // 사용자 프로필 목록 생성
  static List<UserProfile> generateUsers() {
    return List.generate(usersData.length, (index) {
      final userData = usersData[index];
      return UserProfile(
        username: userData['username']!,
        displayName: userData['displayName']!,
        followers: userData['followers']!,
        isVerified: true,
        avatarUrl: profileImages[index % profileImages.length],
      );
    });
  }
}

// === 활동 화면 관련 ===
enum ActivityType { mention, reply, follow, like }

class ActivityItem {
  final ActivityType type;
  final String username;
  final String content;
  final String description;
  final String timeAgo;
  final String avatarUrl;

  ActivityItem({
    required this.type,
    required this.username,
    required this.content,
    required this.description,
    required this.timeAgo,
    required this.avatarUrl,
  });
}

class ActivityData {
  // 더미 활동 데이터
  static const activitiesData = [
    {
      'type': ActivityType.mention,
      'username': 'john_mobbin',
      'content': 'Mentioned you',
      'description':
          'Here\'s a thread you should follow if you love botany @jane_mobbin',
      'timeAgo': '4h',
    },
    {
      'type': ActivityType.reply,
      'username': 'john_mobbin',
      'content': 'Starting out my gardening club with...',
      'description': 'Count me in!',
      'timeAgo': '4h',
    },
    {
      'type': ActivityType.follow,
      'username': 'the.plantdads',
      'content': 'Followed you',
      'description': '',
      'timeAgo': '5h',
    },
    {
      'type': ActivityType.like,
      'username': 'the.plantdads',
      'content': 'Definitely broken! 🧵👀🌿',
      'description': '',
      'timeAgo': '5h',
    },
    {
      'type': ActivityType.like,
      'username': 'theberryjungle',
      'content': '🌿👀🧵',
      'description': '',
      'timeAgo': '5h',
    },
  ];

  // 아이콘
  static const Map<ActivityType, IconData> activityIcons = {
    ActivityType.mention: Icons.alternate_email,
    ActivityType.reply: Icons.reply,
    ActivityType.follow: Icons.person_add,
    ActivityType.like: Icons.favorite,
  };

  // 색상
  static const Map<ActivityType, Color> activityColors = {
    ActivityType.mention: Colors.green,
    ActivityType.reply: Colors.blue,
    ActivityType.follow: Colors.purple,
    ActivityType.like: Colors.pink,
  };

  // 목록 생성
  static List<ActivityItem> generateActivities() {
    return List.generate(activitiesData.length, (index) {
      final data = activitiesData[index];
      return ActivityItem(
        type: data['type'] as ActivityType,
        username: data['username'] as String,
        content: data['content'] as String,
        description: data['description'] as String,
        timeAgo: data['timeAgo'] as String,
        avatarUrl: profileImages[index % profileImages.length],
      );
    });
  }
}
