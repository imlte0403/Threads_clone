import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/sizes.dart';
import '../../constants/gaps.dart';
import '../../widgets/media_picker.dart';

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
  bool _isPosting = false;
  bool _isUploadingImages = false;

  List<File> _attachedMedia = [];
  bool _hasMedia = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _hasText = _textController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // 미디어 첨부 함수
  Future<void> _attachMedia() async {
    try {
      final result = await MediaPicker.show(context);

      if (result != null) {
        setState(() {
          if (result['isMultiple'] == true) {
            _attachedMedia = List<File>.from(result['files']);
          } else {
            _attachedMedia = [result['file']];
          }
          _hasMedia = _attachedMedia.isNotEmpty;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('미디어 첨부 실패: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _attachedMedia.removeAt(index);
      _hasMedia = _attachedMedia.isNotEmpty;
    });
  }

  Widget _buildAttachedMedia() {
    if (!_hasMedia) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _attachedMedia.length,
        itemBuilder: (context, index) {
          final file = _attachedMedia[index];
          final isVideo =
              file.path.toLowerCase().contains('.mp4') ||
              file.path.toLowerCase().contains('.mov');

          return Container(
            width: 120,
            height: 120,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Stack(
              children: [
                // 미디어 프리뷰
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: isVideo
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black,
                          child: const Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                      : Image.file(
                          file,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),

                // 제거 버튼
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeMedia(index),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),

                // 동영상 표시
                if (isVideo)
                  const Positioned(
                    bottom: 4,
                    left: 4,
                    child: Icon(Icons.videocam, color: Colors.white, size: 16),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _createPost() async {
    if ((!_hasText && !_hasMedia) || _isPosting) return;

    setState(() {
      _isPosting = true;
      _isUploadingImages = _hasMedia;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      List<String> mediaUrls = [];

      // TODO: Firebase Storage에 미디어 업로드
      if (_hasMedia) {
        for (File mediaFile in _attachedMedia) {
          mediaUrls.add(mediaFile.path);
        }
      }
      //임시
      final postData = {
        'username': 'jane_mobbin',
        'avatarUrl': widget.avatarUrl,
        'isVerified': true,
        'text': _textController.text.trim(),
        'mediaUrls': mediaUrls,
        'mediaCount': _attachedMedia.length,
        'hasMedia': _hasMedia,
        'replies': 0,
        'likes': 0,
        'likedByAvatars': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
      };

      await firestore.collection('posts').add(postData);

      if (mounted) {
        _textController.clear();
        setState(() {
          _attachedMedia.clear();
          _hasText = false;
          _hasMedia = false;
        });

        Navigator.pop(context);

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
          _isUploadingImages = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canPost = _hasText || _hasMedia;

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
                        Gaps.v8,
                        // 회색 세로선
                        Container(
                          width: 2,
                          height: 100,
                          color: Colors.grey[300],
                        ),
                        Gaps.v8,
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
                            enabled: !_isPosting,
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

                          _buildAttachedMedia(),

                          Gaps.v16,
                          Row(
                            children: [
                              // 미디어 첨부 버튼
                              InkWell(
                                onTap: (_isPosting || _isUploadingImages)
                                    ? null
                                    : _attachMedia,
                                child: Transform.rotate(
                                  angle: 0.75,
                                  child: Icon(
                                    Icons.attach_file,
                                    color: (_isPosting || _isUploadingImages)
                                        ? Colors.grey[400]
                                        : (_hasMedia
                                              ? Colors.blue
                                              : Colors.grey[600]),
                                    size: 20,
                                  ),
                                ),
                              ),

                              // 미디어 첨부 상태 표시
                              if (_hasMedia && !_isUploadingImages) ...[
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${_attachedMedia.length}개 첨부됨',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],

                              // 업로드 중 로딩 표시
                              if (_isUploadingImages) ...[
                                const SizedBox(width: 8),
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '처리중...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
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
                          onPressed: canPost ? _createPost : null,
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: canPost ? Colors.blue : Colors.grey,
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
