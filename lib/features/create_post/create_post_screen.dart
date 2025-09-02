import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../constants/sizes.dart';
import '../../constants/gaps.dart';
import '../../widgets/media_picker.dart';
import '../../constants/app_colors.dart';

// Helper class to hold media file and its type
class _AttachedMediaFile {
  final File file;
  final bool isVideo;

  _AttachedMediaFile({required this.file, required this.isVideo});
}

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
            color: Theme.of(context).colorScheme.secondary,
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onSecondary,
              size: size * 0.6,
            ),
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
            color: Theme.of(context).colorScheme.surface,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onSecondary,
              size: size * 0.6,
            ),
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

  final List<_AttachedMediaFile> _attachedMedia = [];
  bool get _hasMedia => _attachedMedia.isNotEmpty;

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

  Future<void> _attachMedia() async {
    try {
      final result = await MediaPicker.show(context);

      if (result != null && mounted) {
        setState(() {
          if (result['isMultiple'] == true) {
            final List<File> files = result['files'];
            for (var file in files) {
              _attachedMedia.add(
                _AttachedMediaFile(file: file, isVideo: false),
              );
            }
          } else {
            final File file = result['file'];
            final bool isVideo = result['isVideo'] ?? false;
            _attachedMedia.add(
              _AttachedMediaFile(file: file, isVideo: isVideo),
            );
          }
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
          final media = _attachedMedia[index];
          final fileExists = media.file.existsSync();

          return Container(
            width: 120,
            height: 120,
            margin: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: !fileExists
                        ? Container(
                            color: Theme.of(context).colorScheme.surface,
                            child: Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                                size: 40,
                              ),
                            ),
                          )
                        : media.isVideo
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
                            media.file,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
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
                if (media.isVideo)
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

  Future<String> _uploadFile(File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('posts/')
        .child(fileName);

    final UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
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

      if (_hasMedia) {
        for (_AttachedMediaFile media in _attachedMedia) {
          final url = await _uploadFile(media.file);
          mediaUrls.add(url);
        }
      }

      final postData = {
        'username': 'jane_mobbin',
        'avatarUrl': widget.avatarUrl,
        'isVerified': true,
        'text': _textController.text.trim(),
        'imageUrls': mediaUrls,
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
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 80,
          leading: TextButton(
            onPressed: _isPosting ? null : () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: _isPosting
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ),
          title: const Text(
            'New thread',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(height: 1.0),
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
                    _AvatarNetwork(size: Sizes.size36, url: widget.avatarUrl),
                    Gaps.h16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'jane_mobbin',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Gaps.v8,
                          TextField(
                            controller: _textController,
                            maxLines: null,
                            enabled: !_isPosting,
                            decoration: InputDecoration(
                              filled: false,
                              hintText: 'Start a thread...',
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.label(context),
                            ),
                          ),
                          _buildAttachedMedia(),
                          Gaps.v16,
                          Row(
                            children: [
                              InkWell(
                                onTap: (_isPosting || _isUploadingImages)
                                    ? null
                                    : _attachMedia,
                                child: Transform.rotate(
                                  angle: 0.75,
                                  child: Icon(
                                    Icons.attach_file,
                                    color: (_isPosting || _isUploadingImages)
                                        ? Theme.of(context).disabledColor
                                        : (_hasMedia
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).hintColor),
                                    size: 20,
                                  ),
                                ),
                              ),
                              if (_hasMedia && !_isUploadingImages) ...[
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${_attachedMedia.length}개 첨부됨',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                              if (_isUploadingImages) ...[
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '처리중...',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Anyone can reply',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 14,
                    ),
                  ),
                  _isPosting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: canPost ? _createPost : null,
                          child: Text(
                            'Post',
                            style: TextStyle(
                              color: canPost
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
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
