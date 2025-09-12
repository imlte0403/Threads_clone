import '../../models/post_model.dart';

class ProfileModel {
  final String username;
  final String displayName;
  final String userId;
  final String bio;
  final String followers;
  final String avatarUrl;
  final bool isVerified;

  ProfileModel({
    required this.username,
    required this.displayName,
    required this.userId,
    required this.bio,
    required this.followers,
    required this.avatarUrl,
    required this.isVerified,
  });
}

class ProfilePostModel {
  final String username;
  final String timeAgo;
  final String text;
  final int replies;
  final int likes;
  final List<String> imageUrls;
  final List<String> likedByAvatars;
  final bool isVerified;
  final String? avatarUrl;

  ProfilePostModel({
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

  PostModel toPostModel() {
    return PostModel(
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


class ProfileDataProvider {
  // 임시 프로필
  static ProfileModel get demoProfile => ProfileModel(
    username: 'Jane',
    displayName: 'jane_mobbin',
    userId: 'jane_mobbin',
    bio: 'Plant enthusiast!',
    followers: '2 followers',
    avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop&crop=face',
    isVerified: false,
  );

  // 프로필 생성 메서드
  static ProfileModel createProfile({
    required String username,
    required String displayName,
    required String userId,
    required String bio,
    required String followers,
    required String avatarUrl,
    bool isVerified = false,
  }) {
    return ProfileModel(
      username: username,
      displayName: displayName,
      userId: userId,
      bio: bio,
      followers: followers,
      avatarUrl: avatarUrl,
      isVerified: isVerified,
    );
  }

  // TODO: 실제 API 호출로 대체 필요
  static List<ProfilePostModel> get demoThreadsData => [
    ProfilePostModel(
      username: 'jane_mobbin',
      timeAgo: '5h',
      text: 'Give @john_mobbin a follow if you want to see more travel content!',
      replies: 12,
      likes: 24,
      avatarUrl: demoProfile.avatarUrl,
      likedByAvatars: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face',
      ],
    ),
    ProfilePostModel(
      username: 'jane_mobbin',
      timeAgo: '6h',
      text: 'Tea. Spillage.',
      replies: 8,
      likes: 45,
      avatarUrl: demoProfile.avatarUrl,
      imageUrls: [
        'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=400&fit=crop',
      ],
      likedByAvatars: [
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?w=100&h=100&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop&crop=face',
      ],
    ),
  ];

  // TODO: 실제 API 호출로 대체 필요
  static List<ProfilePostModel> get demoRepliesData => [
    ProfilePostModel(
      username: 'jane_mobbin',
      timeAgo: '5h',
      text: 'See you there!',
      replies: 3,
      likes: 12,
      avatarUrl: demoProfile.avatarUrl,
      likedByAvatars: [
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&h=100&fit=crop&crop=face',
      ],
    ),
    ProfilePostModel(
      username: 'jane_mobbin',
      timeAgo: '8h',
      text: 'Always a dream to see the Medina in Morocco!',
      replies: 15,
      likes: 67,
      avatarUrl: demoProfile.avatarUrl,
      likedByAvatars: [
        'https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?w=100&h=100&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1463453091185-61582044d556?w=100&h=100&fit=crop&crop=face',
      ],
    ),
  ];
}
