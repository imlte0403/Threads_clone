import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thread_clone/constants/gaps.dart';
import 'package:thread_clone/constants/sizes.dart';
import '../view/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "recordMedia";
  static const String routeURL = "/record";

  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  bool _isRecording = false;
  bool _isPhotoMode = true; 

  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late final AnimationController _buttonAnimationController =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );

  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late FlashMode _flashMode;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    if (!_noCamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_noCamera) return;
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _cameraController.initialize();
    await _cameraController.prepareForVideoRecording();
    _flashMode = _cameraController.value.flashMode;

    setState(() {});
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  // 사진 촬영
  Future<void> _takePicture() async {
    if (!_cameraController.value.isInitialized) return;

    try {
      _buttonAnimationController.forward();
      final image = await _cameraController.takePicture();
      _buttonAnimationController.reverse();

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VideoPreviewScreen(media: image, isVideo: false, isPicked: false),
        ),
      );
    } catch (e) {
      _buttonAnimationController.reverse();
      print('사진 촬영 오류: $e');
    }
  }

  // 동영상 촬영 시작
  Future<void> _startVideoRecording() async {
    if (_cameraController.value.isRecordingVideo) return;

    try {
      await _cameraController.startVideoRecording();
      _buttonAnimationController.forward();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('동영상 촬영 시작 오류: $e');
    }
  }

  // 동영상 촬영 종료
  Future<void> _stopVideoRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    try {
      _buttonAnimationController.reverse();
      final video = await _cameraController.stopVideoRecording();

      setState(() {
        _isRecording = false;
      });

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VideoPreviewScreen(media: video, isVideo: true, isPicked: false),
        ),
      );
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      print('동영상 촬영 종료 오류: $e');
    }
  }

  // 갤러리에서 선택
  Future<void> _pickFromGallery() async {
    try {
      XFile? pickedFile;

      if (_isPhotoMode) {
        pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 20, 
          maxWidth: 1080,
          maxHeight: 1080,
        );
      } else {
        pickedFile = await ImagePicker().pickVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 30),
        );
      }

      if (pickedFile == null) return;

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPreviewScreen(
            media: pickedFile!,
            isVideo: !_isPhotoMode,
            isPicked: true,
          ),
        ),
      );
    } catch (e) {
      print('갤러리 선택 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "카메라 권한이 필요합니다",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Gaps.v20,
                  Text(
                    "설정에서 카메라 권한을 허용해주세요",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              )
            : !_cameraController.value.isInitialized
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  Gaps.v20,
                  Text(
                    "카메라 준비중...",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  // 카메라 프리뷰
                  CameraPreview(_cameraController),

                  // 상단 컨트롤
                  Positioned(
                    top: Sizes.size80,
                    right: Sizes.size20,
                    child: Column(
                      children: [
                        // 플래시 모드
                        IconButton(
                          color: _flashMode == FlashMode.off
                              ? Colors.white
                              : Colors.yellow,
                          onPressed: () => _setFlashMode(
                            _flashMode == FlashMode.off
                                ? FlashMode.torch
                                : FlashMode.off,
                          ),
                          icon: Icon(
                            _flashMode == FlashMode.off
                                ? Icons.flash_off
                                : Icons.flash_on,
                          ),
                        ),
                        Gaps.v10,
                        // 카메라 전환
                        IconButton(
                          color: Colors.white,
                          onPressed: _toggleSelfieMode,
                          icon: const Icon(Icons.cameraswitch),
                        ),
                      ],
                    ),
                  ),

                  // 사진/동영상 모드 선택
                  Positioned(
                    top: Sizes.size80,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size20,
                        vertical: Sizes.size8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isPhotoMode = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size16,
                                vertical: Sizes.size8,
                              ),
                              decoration: BoxDecoration(
                                color: _isPhotoMode ? Colors.white : null,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                "사진",
                                style: TextStyle(
                                  color: _isPhotoMode
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Gaps.h16,
                          GestureDetector(
                            onTap: () => setState(() => _isPhotoMode = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size16,
                                vertical: Sizes.size8,
                              ),
                              decoration: BoxDecoration(
                                color: !_isPhotoMode ? Colors.white : null,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                "동영상",
                                style: TextStyle(
                                  color: !_isPhotoMode
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 하단 컨트롤
                  Positioned(
                    bottom: Sizes.size100,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        // 갤러리 버튼
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _pickFromGallery,
                              icon: const Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),

                        // 촬영 버튼
                        GestureDetector(
                          onTap: _isPhotoMode
                              ? _takePicture
                              : (_isRecording
                                    ? _stopVideoRecording
                                    : _startVideoRecording),
                          child: ScaleTransition(
                            scale: _buttonAnimation,
                            child: Container(
                              width: Sizes.size80,
                              height: Sizes.size80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isPhotoMode
                                    ? Colors.white
                                    : (_isRecording
                                          ? Colors.red
                                          : Colors.white),
                                border: Border.all(
                                  color: _isPhotoMode
                                      ? Colors.black26
                                      : Colors.white,
                                  width: 6,
                                ),
                              ),
                              child: _isRecording
                                  ? const Icon(
                                      Icons.stop,
                                      color: Colors.white,
                                      size: 32,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),

                  // 닫기 버튼
                  Positioned(
                    top: Sizes.size80,
                    left: Sizes.size20,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
