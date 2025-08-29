import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../features/video/view/video_recording_screen.dart';
import '../features/video/view/video_preview_screen.dart';

class MediaPicker extends StatelessWidget {
  const MediaPicker({super.key});

  static Future<Map<String, dynamic>?> show(BuildContext context) async {
    if (Platform.isIOS) {
      return await _showIOSActionSheet(context);
    } else {
      return await _showAndroidBottomSheet(context);
    }
  }

  // iOS 스타일 ActionSheet
  static Future<Map<String, dynamic>?> _showIOSActionSheet(
    BuildContext context,
  ) async {
    return await showCupertinoModalPopup<Map<String, dynamic>>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('미디어 추가'),
        message: const Text('사진이나 동영상을 선택해주세요'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final result = await _openCamera(context);
              if (result != null) {
                Navigator.pop(context, result);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.camera, size: 20),
                SizedBox(width: 8),
                Text('카메라로 촬영'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final result = await _pickFromGallery(context);
              if (result != null) {
                Navigator.pop(context, result);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.photo, size: 20),
                SizedBox(width: 8),
                Text('갤러리에서 선택'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
      ),
    );
  }

  // Android 스타일 BottomSheet
  static Future<Map<String, dynamic>?> _showAndroidBottomSheet(
    BuildContext context,
  ) async {
    return await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들바
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const Text(
              '미디어 추가',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            const Text(
              '사진이나 동영상을 선택해주세요',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // 카메라 옵션
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('카메라로 촬영'),
              onTap: () async {
                Navigator.pop(context);
                final result = await _openCamera(context);
                if (result != null) {
                  Navigator.pop(context, result);
                }
              },
            ),

            // 갤러리 옵션
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리에서 선택'),
              onTap: () async {
                Navigator.pop(context);
                final result = await _pickFromGallery(context);
                if (result != null) {
                  Navigator.pop(context, result);
                }
              },
            ),

            const SizedBox(height: 20),

            // 취소 버튼
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '취소',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 카메라 열기
  static Future<Map<String, dynamic>?> _openCamera(BuildContext context) async {
    try {
      final result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(builder: (context) => const VideoRecordingScreen()),
      );
      return result;
    } catch (e) {
      print('카메라 열기 오류: $e');
      return null;
    }
  }

  // 갤러리에서 선택 (다중 선택 지원)
  static Future<Map<String, dynamic>?> _pickFromGallery(
    BuildContext context,
  ) async {
    try {
      // 단일 미디어 선택 다이얼로그
      return await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('갤러리에서 선택'),
          content: const Text('사진 또는 동영상을 선택하세요'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _pickImages(context);
              },
              child: const Text('사진'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _pickVideo(context);
              },
              child: const Text('동영상'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('갤러리 선택 오류: $e');
      return null;
    }
  }

  // 이미지 선택 (최대 3장)
  static Future<void> _pickImages(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        imageQuality: 20, // 80% 압축
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (images.isNotEmpty) {
        // 최대 3장 제한
        final limitedImages = images.take(3).toList();

        if (images.length > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('최대 3장까지만 선택할 수 있습니다.'),
              duration: Duration(seconds: 2),
            ),
          );
        }

        // 선택된 이미지들을 처리
        final List<File> imageFiles = limitedImages
            .map((xfile) => File(xfile.path))
            .toList();

        Navigator.pop(context, {
          'files': imageFiles,
          'isVideo': false,
          'isMultiple': imageFiles.length > 1,
        });
      }
    } catch (e) {
      print('이미지 선택 오류: $e');
    }
  }

  // 동영상 선택
  static Future<void> _pickVideo(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60), // 최대 1분
      );

      if (video != null) {
        // 미리보기 화면으로 이동
        final result = await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VideoPreviewScreen(media: video, isVideo: true, isPicked: true),
          ),
        );

        if (result != null) {
          Navigator.pop(context, result);
        }
      }
    } catch (e) {
      print('동영상 선택 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 이 위젯은 직접 사용되지 않고 static 메서드만 사용됨
    return const SizedBox.shrink();
  }
}
