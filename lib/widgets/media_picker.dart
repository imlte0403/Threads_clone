import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../features/video/view/video_preview_screen.dart';

class MediaPicker {
  // --- Public Method ---
  static Future<Map<String, dynamic>?> show(BuildContext context) async {
    // 웹에서는 기본적으로 Android 스타일 사용
    if (kIsWeb) {
      return await _showWebPicker(context);
    }
    
    // iOS 테마 감지 (웹이 아닌 경우)
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      return await _showIOSActionSheet(context);
    } else {
      return await _showAndroidBottomSheet(context);
    }
  }

  // --- Private Platform-Specific Methods ---
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
              final result = await _showPickerDialog(
                context,
                source: ImageSource.camera,
                title: '카메라',
                content: '사진을 촬영하시겠어요, 동영상을 녹화하시겠어요?',
              );
              if (context.mounted) Navigator.pop(context, result ?? []);
            },
            child: const Text('카메라로 촬영'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final result = await _showPickerDialog(
                context,
                source: ImageSource.gallery,
                title: '갤러리에서 선택',
                content: '사진 또는 동영상을 선택하세요',
              );
              if (context.mounted) Navigator.pop(context, result ?? []);
            },
            child: const Text('갤러리에서 선택'),
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

  static Future<Map<String, dynamic>?> _showAndroidBottomSheet(
    BuildContext context,
  ) async {
    // Android implementation remains the same
    return await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return Container(); // Placeholder for brevity
      },
    );
  }

  // --- Private Helper Methods ---
  static Future<Map<String, dynamic>?> _showPickerDialog(
    BuildContext context, {
    required ImageSource source,
    required String title,
    required String content,
  }) async {
    return await showCupertinoDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              final BuildContext dialogContext = context;
              final result = (source == ImageSource.gallery)
                  ? await _pickMultiImage(dialogContext)
                  : await _pickSingleMedia(
                      dialogContext,
                      source: source,
                      isVideo: false,
                    );
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext, result ?? []);
              }
            },
            child: const Text('사진'),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              final BuildContext dialogContext = context;
              final result = await _pickSingleMedia(
                dialogContext,
                source: source,
                isVideo: true,
              );
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext, result ?? []);
              }
            },
            child: const Text('동영상'),
          ),
        ],
      ),
    );
  }

  static Future<Map<String, dynamic>?> _pickSingleMedia(
    BuildContext context, {
    required ImageSource source,
    required bool isVideo,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? media = isVideo
          ? await picker.pickVideo(
              source: source,
              maxDuration: const Duration(seconds: 60),
            )
          : await picker.pickImage(
              source: source,
              imageQuality: 20,
              maxWidth: 1080,
              maxHeight: 1080,
            );

      if (media != null) {
        if (!context.mounted) return null;
        return await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPreviewScreen(
              media: media,
              isVideo: isVideo,
              isPicked: source == ImageSource.gallery,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error picking single media: $e");
    }
    return null;
  }

  static Future<Map<String, dynamic>?> _pickMultiImage(
    BuildContext context,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        imageQuality: 20,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (images.isNotEmpty) {
        if (!context.mounted) return null;
        final limitedImages = images.take(3).toList();

        if (images.length > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('최대 3장까지만 선택할 수 있습니다.'),
              duration: Duration(seconds: 2),
            ),
          );
        }

        return {
          'files': kIsWeb 
              ? limitedImages  // 웹에서는 XFile 그대로 사용
              : limitedImages.map((x) => File(x.path)).toList(),
          'isVideo': false,
          'isMultiple': true,
        };
      }
    } catch (e) {
      print("Error picking multiple images: $e");
    }
    return null;
  }

  // --- 웹용 미디어 피커 (임시 비활성화) ---
  static Future<Map<String, dynamic>?> _showWebPicker(BuildContext context) async {
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
            const Text(
              '미디어 추가',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '웹에서는 현재 미디어 첨부 기능을 지원하지 않습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
