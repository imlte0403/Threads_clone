import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:image/image.dart' as img;
import 'package:thread_clone/constants/gaps.dart';
import 'package:thread_clone/constants/sizes.dart';

class VideoPreviewScreen extends StatefulWidget {
  final XFile media;
  final bool isVideo;
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.media,
    required this.isVideo,
    required this.isPicked,
  });

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  VideoPlayerController? _videoPlayerController;
  File? _processedImageFile;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _initVideo();
    } else {
      _compressImage();
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _initVideo() async {
    setState(() => _isProcessing = true);

    _videoPlayerController = VideoPlayerController.file(
      File(widget.media.path),
    );

    await _videoPlayerController!.initialize();
    await _videoPlayerController!.setLooping(true);
    await _videoPlayerController!.play();

    setState(() => _isProcessing = false);
  }

  Future<void> _compressImage() async {
    setState(() => _isProcessing = true);

    try {
      final bytes = await File(widget.media.path).readAsBytes();
      final originalImage = img.decodeImage(bytes);

      //용량 제한
      if (originalImage != null) {
        img.Image resized = originalImage;
        if (originalImage.width > 1080 || originalImage.height > 1080) {
          resized = img.copyResize(
            originalImage,
            width: originalImage.width > originalImage.height ? 1080 : null,
            height: originalImage.height > originalImage.width ? 1080 : null,
          );
        }

        final compressedBytes = img.encodeJpg(resized, quality: 20);

        final tempDir = Directory.systemTemp;
        final tempFile = File(
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await tempFile.writeAsBytes(compressedBytes);

        _processedImageFile = tempFile;
      }
    } catch (e) {
      _processedImageFile = File(widget.media.path);
    }

    setState(() => _isProcessing = false);
  }

  void _confirmSelection() {
    final resultFile = widget.isVideo
        ? File(widget.media.path)
        : _processedImageFile ?? File(widget.media.path);

    if (resultFile.existsSync()) {
      Navigator.pop(context, {'file': resultFile, 'isVideo': widget.isVideo});
    } else {
      Navigator.pop(context, {});
    }
  }

  void _retake() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.black,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _retake,
          child: const Text("다시 촬영", style: TextStyle(color: Colors.white)),
        ),
        middle: Text(
          widget.isVideo ? '동영상 미리보기' : '사진 미리보기',
          style: const TextStyle(color: Colors.white),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _confirmSelection,
          child: const Text(
            "사용하기",
            style: TextStyle(
              color: CupertinoColors.activeBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      child: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(color: Colors.white),
                  Gaps.v20,
                  Text(
                    "처리 중...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Center(
                  child: widget.isVideo
                      ? _videoPlayerController?.value.isInitialized == true
                            ? AspectRatio(
                                aspectRatio:
                                    _videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController!),
                              )
                            : const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                      : _processedImageFile != null
                      ? Image.file(_processedImageFile!, fit: BoxFit.contain)
                      : const CupertinoActivityIndicator(color: Colors.white),
                ),
                if (widget.isVideo &&
                    _videoPlayerController?.value.isInitialized == true)
                  Center(
                    child: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          if (_videoPlayerController!.value.isPlaying) {
                            _videoPlayerController!.pause();
                          } else {
                            _videoPlayerController!.play();
                          }
                        });
                      },
                      padding: const EdgeInsets.all(Sizes.size12),
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(100),
                      child: Icon(
                        _videoPlayerController!.value.isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
