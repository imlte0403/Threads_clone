import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/gaps.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserProfile> _filteredUsers = [];
  List<UserProfile> _allUsers = [];

  // dev_seed.dart에서 가져온 이미지 URL들
  final List<String> _profileImages = [
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

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadUsers() {
    // 사용자 데이터
    final usersData = [
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

    // UserProfile 생성
    _allUsers = List.generate(usersData.length, (index) {
      final userData = usersData[index];
      return UserProfile(
        username: userData['username']!,
        displayName: userData['displayName']!,
        followers: userData['followers']!,
        isVerified: true,
        avatarUrl: _profileImages[index % _profileImages.length],
      );
    });

    _filteredUsers = List.from(_allUsers);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = List.from(_allUsers);
      } else {
        _filteredUsers = _allUsers.where((user) {
          return user.username.toLowerCase().contains(query) ||
              user.displayName.toLowerCase().contains(query);
        }).toList();
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
            // 제목
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Search',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // 검색 입력창
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search',
                style: TextStyle(fontSize: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            Gaps.v20,

            // 사용자 리스트
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return _UserTile(user: user);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserTile extends StatefulWidget {
  final UserProfile user;

  const _UserTile({required this.user});

  @override
  State<_UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<_UserTile> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: _buildAvatar(),
      title: _buildUserInfo(),
      trailing: _buildFollowButton(),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: 50,
      height: 50,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: widget.user.avatarUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.user.username,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            if (widget.user.isVerified) ...[
              Gaps.h4,
              Icon(Icons.verified, size: 16, color: Colors.blue),
            ],
          ],
        ),
        Text(
          widget.user.displayName,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Gaps.v8,
        Text(
          '${widget.user.followers} followers',
          style: TextStyle(fontSize: 14, color: Colors.grey[900]),
        ),
      ],
    );
  }

  Widget _buildFollowButton() {
    return Container(
      width: 100,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(
          color: isFollowing ? Colors.grey.shade300 : Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            isFollowing = !isFollowing;
          });
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// 사용자 프로필 데이터 모델
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
