import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
  File? _compressedImageFile;
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

        _compressedImageFile = tempFile;

        print('원본 크기: ${bytes.length} bytes');
        print('압축 후 크기: ${compressedBytes.length} bytes');
        print(
          '압축률: ${((1 - compressedBytes.length / bytes.length) * 100).toStringAsFixed(1)}%',
        );
      }
    } catch (e) {
      print('이미지 압축 오류: $e');

      _compressedImageFile = File(widget.media.path);
    }

    setState(() => _isProcessing = false);
  }

  void _useMedia() {
    final resultFile = widget.isVideo
        ? File(widget.media.path)
        : _compressedImageFile ?? File(widget.media.path);

    Navigator.pop(context, {'file': resultFile, 'isVideo': widget.isVideo});
  }

  void _retake() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: _retake,
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: Text(
          widget.isVideo ? '동영상 미리보기' : '사진 미리보기',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  Gaps.v20,
                  Text(
                    "처리 중...",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // 미디어 표시
                Center(
                  child: widget.isVideo
                      ? _videoPlayerController?.value.isInitialized == true
                            ? AspectRatio(
                                aspectRatio:
                                    _videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController!),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              )
                      : _compressedImageFile != null
                      ? Image.file(_compressedImageFile!, fit: BoxFit.contain)
                      : const CircularProgressIndicator(color: Colors.white),
                ),

                // 하단 버튼들
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(Sizes.size20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: TextButton(
                                onPressed: _retake,
                                child: const Text(
                                  "다시 촬영",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Gaps.h16,

                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextButton(
                                onPressed: _useMedia,
                                child: const Text(
                                  "사용하기",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (widget.isVideo &&
                    _videoPlayerController?.value.isInitialized == true)
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_videoPlayerController!.value.isPlaying) {
                            _videoPlayerController!.pause();
                          } else {
                            _videoPlayerController!.play();
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Sizes.size12),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _videoPlayerController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
