import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/sizes.dart';
import '../../constants/gaps.dart';

class _AvatarNetwork extends StatelessWidget {
  const _AvatarNetwork({required this.size, this.url});
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
            child: Icon(Icons.person, color: Colors.white, size: size * 0.6),
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
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xFFE3F2FD),
            child: Icon(Icons.person, color: Colors.white, size: size * 0.6),
          ),
        ),
      ),
    );
  }
}

class CreatePostScreen extends StatefulWidget {
  final String avatarUrl;

  const CreatePostScreen({super.key, required this.avatarUrl});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _hasText = false;
  bool _isPosting = false; // 포스트 중인지 상태 추가

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _hasText = _textController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Firestore에 게시글 저장하는 함수
  Future<void> _createPost() async {
    if (!_hasText || _isPosting) return;

    setState(() {
      _isPosting = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;

      // 새 게시글 데이터 준비
      final postData = {
        'username': 'jane_mobbin', // 실제로는 현재 사용자 정보를 가져와야 함
        'avatarUrl': widget.avatarUrl,
        'isVerified': true, // 실제로는 사용자의 인증 상태를 확인해야 함
        'text': _textController.text.trim(),
        'imageUrls': <String>[], // 현재는 이미지 없이, 추후 이미지 업로드 기능 추가 가능
        'replies': 0,
        'likes': 0,
        'likedByAvatars': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Firestore에 저장
      await firestore.collection('posts').add(postData);

      // 성공 시 화면 닫기
      if (mounted) {
        Navigator.pop(context);

        // 성공 메시지 표시 (선택사항)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('게시글이 성공적으로 등록되었습니다!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게시글 등록에 실패했습니다: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      print('게시글 저장 오류: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 80,
          leading: TextButton(
            onPressed: _isPosting ? null : () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: _isPosting ? Colors.grey : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          title: const Text(
            'New thread',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: Colors.grey[300], height: 1.0),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 왼쪽 프로필 섹션
                    Column(
                      children: [
                        // 큰 프로필 이미지
                        _AvatarNetwork(
                          size: Sizes.size36,
                          url: widget.avatarUrl,
                        ),
                        Gaps.h8,
                        // 회색 세로선
                        Container(
                          width: 2,
                          height: 100,
                          color: Colors.grey[300],
                        ),
                        Gaps.h8,
                        // 작은 프로필 이미지
                        _AvatarNetwork(
                          size: Sizes.size20,
                          url: widget.avatarUrl,
                        ),
                      ],
                    ),
                    Gaps.h16,
                    // 오른쪽 텍스트 입력 섹션
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 사용자명
                          const Text(
                            'jane_mobbin',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Gaps.v8,
                          // 텍스트 입력 필드
                          TextField(
                            controller: _textController,
                            maxLines: null,
                            enabled: !_isPosting, // 포스팅 중에는 비활성화
                            decoration: const InputDecoration(
                              hintText: 'Start a thread...',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Gaps.h16,
                          // 첨부 아이콘
                          InkWell(
                            onTap: _isPosting
                                ? null
                                : () {
                                    // 첨부 기능 구현
                                    print('Attachment tapped');
                                  },
                            child: Transform.rotate(
                              angle: 0.75,
                              child: Icon(
                                Icons.attach_file,
                                color: _isPosting
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 하단 영역
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Anyone can reply',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  // Post 버튼
                  _isPosting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: _hasText ? _createPost : null,
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: _hasText ? Colors.blue : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
