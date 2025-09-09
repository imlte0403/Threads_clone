import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../repositories/post_repository.dart';
import '../../services/storage_service.dart';
import '../../utils/firebase_exceptions.dart';

part 'write_view_model.g.dart';

@riverpod
class WriteViewModel extends _$WriteViewModel {
  @override
  WriteState build() {
    return const WriteState();
  }

  // ==================== Text Management ====================

  /// 텍스트 내용 업데이트
  void updateText(String text) {
    state = state.copyWith(
      text: text,
      hasText: text.trim().isNotEmpty,
    );
  }

  /// 텍스트 초기화
  void clearText() {
    state = state.copyWith(
      text: '',
      hasText: false,
    );
  }

  // ==================== Media Management ====================

  /// 미디어 파일 추가
  void addMediaFiles(List<File> files) {
    final updatedMediaFiles = [...state.mediaFiles, ...files];
    state = state.copyWith(
      mediaFiles: updatedMediaFiles,
      hasMedia: updatedMediaFiles.isNotEmpty,
    );
  }

  /// 단일 미디어 파일 추가
  void addMediaFile(File file) {
    addMediaFiles([file]);
  }

  /// 미디어 파일 제거
  void removeMediaFile(int index) {
    if (index >= 0 && index < state.mediaFiles.length) {
      final updatedMediaFiles = List<File>.from(state.mediaFiles);
      updatedMediaFiles.removeAt(index);
      state = state.copyWith(
        mediaFiles: updatedMediaFiles,
        hasMedia: updatedMediaFiles.isNotEmpty,
      );
    }
  }

  /// 모든 미디어 파일 제거
  void clearMediaFiles() {
    state = state.copyWith(
      mediaFiles: [],
      hasMedia: false,
    );
  }

  // ==================== Post Creation ====================

  /// 게시물 작성
  Future<void> createPost() async {
    if (!_canPost()) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final storageService = ref.read(storageServiceProvider);
      final postRepository = ref.read(postRepositoryProvider);

      // 1. 이미지 업로드
      List<String> imageUrls = [];
      if (state.hasMedia) {
        state = state.copyWith(isUploadingMedia: true);
        imageUrls = await storageService.uploadPostImages(state.mediaFiles);
        state = state.copyWith(isUploadingMedia: false);
      }

      // 2. 게시물 생성
      await postRepository.createAnonymousPost(
        text: state.text.trim(),
        imageUrls: imageUrls,
      );

      // 3. 성공 처리
      _resetState();
      state = state.copyWith(isSuccess: true);

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isUploadingMedia: false,
        errorMessage: FirebaseExceptionHandler.handleGenericException(e),
      );
    }
  }

  /// 진행률과 함께 게시물 작성
  Future<void> createPostWithProgress() async {
    if (!_canPost()) return;

    state = state.copyWith(isLoading: true, errorMessage: null, uploadProgress: 0.0);

    try {
      final storageService = ref.read(storageServiceProvider);
      final postRepository = ref.read(postRepositoryProvider);

      List<String> imageUrls = [];
      
      if (state.hasMedia) {
        state = state.copyWith(isUploadingMedia: true);
        
        // 각 파일 업로드 진행률 추적
        for (int i = 0; i < state.mediaFiles.length; i++) {
          final file = state.mediaFiles[i];
          
          final url = await storageService.uploadPostImageWithProgress(
            file,
            onProgress: (progress) {
              final totalProgress = (i + progress) / state.mediaFiles.length;
              state = state.copyWith(uploadProgress: totalProgress);
            },
          );
          
          imageUrls.add(url);
        }
        
        state = state.copyWith(isUploadingMedia: false, uploadProgress: 1.0);
      }

      // 게시물 생성
      await postRepository.createAnonymousPost(
        text: state.text.trim(),
        imageUrls: imageUrls,
      );

      // 성공 처리
      _resetState();
      state = state.copyWith(isSuccess: true);

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isUploadingMedia: false,
        uploadProgress: 0.0,
        errorMessage: FirebaseExceptionHandler.handleGenericException(e),
      );
    }
  }

  // ==================== Validation ====================

  /// 게시할 수 있는지 확인
  bool _canPost() {
    return (state.hasText || state.hasMedia) && !state.isLoading;
  }

  /// 게시 가능 여부 getter
  bool get canPost => _canPost();

  /// 텍스트 길이 제한 확인
  bool get isTextTooLong => state.text.length > 500; // 예: 500자 제한

  /// 미디어 파일 개수 제한 확인
  bool get isTooManyMedia => state.mediaFiles.length > 10; // 예: 10개 제한

  // ==================== State Management ====================

  /// 상태 초기화
  void _resetState() {
    state = const WriteState();
  }

  /// 전체 초기화 (사용자 명시적 리셋)
  void reset() {
    _resetState();
  }

  /// 에러 메시지 클리어
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 성공 상태 클리어
  void clearSuccess() {
    state = state.copyWith(isSuccess: false);
  }

  // ==================== File Validation ====================

  /// 파일 유효성 검사
  String? validateFile(File file) {
    final storageService = ref.read(storageServiceProvider);
    
    // 파일 크기 확인 (10MB)
    if (!storageService.isFileSizeValid(file, maxSizeInMB: 10)) {
      return '파일 크기는 10MB 이하여야 합니다.';
    }
    
    // 파일 형식 확인
    if (!storageService.isImageFile(file.path) && !storageService.isVideoFile(file.path)) {
      return '지원하지 않는 파일 형식입니다.';
    }
    
    return null;
  }

  /// 여러 파일 유효성 검사
  List<String> validateFiles(List<File> files) {
    final List<String> errors = [];
    
    for (final file in files) {
      final error = validateFile(file);
      if (error != null) {
        errors.add(error);
      }
    }
    
    return errors;
  }
}

/// Write Screen의 상태 클래스
class WriteState {
  final String text;
  final List<File> mediaFiles;
  final bool hasText;
  final bool hasMedia;
  final bool isLoading;
  final bool isUploadingMedia;
  final bool isSuccess;
  final String? errorMessage;
  final double uploadProgress;

  const WriteState({
    this.text = '',
    this.mediaFiles = const [],
    this.hasText = false,
    this.hasMedia = false,
    this.isLoading = false,
    this.isUploadingMedia = false,
    this.isSuccess = false,
    this.errorMessage,
    this.uploadProgress = 0.0,
  });

  /// 상태 복사 메서드
  WriteState copyWith({
    String? text,
    List<File>? mediaFiles,
    bool? hasText,
    bool? hasMedia,
    bool? isLoading,
    bool? isUploadingMedia,
    bool? isSuccess,
    String? errorMessage,
    double? uploadProgress,
  }) {
    return WriteState(
      text: text ?? this.text,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      hasText: hasText ?? this.hasText,
      hasMedia: hasMedia ?? this.hasMedia,
      isLoading: isLoading ?? this.isLoading,
      isUploadingMedia: isUploadingMedia ?? this.isUploadingMedia,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  /// 전체 진행 중인지 확인
  bool get isBusy => isLoading || isUploadingMedia;

  /// 게시 가능한지 확인
  bool get canPost => (hasText || hasMedia) && !isBusy;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WriteState &&
        other.text == text &&
        other.hasText == hasText &&
        other.hasMedia == hasMedia &&
        other.isLoading == isLoading &&
        other.isUploadingMedia == isUploadingMedia &&
        other.isSuccess == isSuccess &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hasText.hashCode ^
        hasMedia.hashCode ^
        isLoading.hashCode ^
        isUploadingMedia.hashCode ^
        isSuccess.hashCode ^
        (errorMessage?.hashCode ?? 0);
  }

  @override
  String toString() {
    return 'WriteState('
        'text: $text, '
        'hasText: $hasText, '
        'hasMedia: $hasMedia, '
        'isLoading: $isLoading, '
        'isUploadingMedia: $isUploadingMedia, '
        'isSuccess: $isSuccess, '
        'errorMessage: $errorMessage'
        ')';
  }
}