import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/firebase_constants.dart';
import '../utils/firebase_exceptions.dart';

part 'storage_service.g.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 게시물 이미지 업로드
  /// [file] 업로드할 파일
  /// [fileName] 파일명 (null인 경우 자동 생성)
  /// 반환값: 다운로드 URL
  Future<String> uploadPostImage(File file, {String? fileName}) async {
    try {
      final String finalFileName = fileName ?? _generateFileName();
      final Reference ref = _storage
          .ref()
          .child(FirebaseConstants.postsStoragePath)
          .child(finalFileName);
      
      final UploadTask uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: _getContentType(file.path),
          customMetadata: {
            'uploadedAt': DateTime.now().toIso8601String(),
            'type': 'post_image',
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleStorageException(e);
    } catch (e) {
      throw '이미지 업로드에 실패했습니다: ${e.toString()}';
    }
  }

  /// 여러 이미지 업로드 (배치 처리)
  /// [files] 업로드할 파일 리스트
  /// 반환값: 다운로드 URL 리스트
  Future<List<String>> uploadPostImages(List<File> files) async {
    if (files.isEmpty) return [];
    
    try {
      final List<Future<String>> uploadTasks = files.map((file) {
        return uploadPostImage(file);
      }).toList();
      
      final List<String> urls = await Future.wait(uploadTasks);
      return urls;
    } catch (e) {
      throw '이미지 업로드에 실패했습니다: ${e.toString()}';
    }
  }

  /// 업로드 진행률 모니터링과 함께 이미지 업로드
  /// [file] 업로드할 파일
  /// [onProgress] 진행률 콜백 (0.0 ~ 1.0)
  /// [fileName] 파일명
  /// 반환값: 다운로드 URL
  Future<String> uploadPostImageWithProgress(
    File file, {
    Function(double)? onProgress,
    String? fileName,
  }) async {
    try {
      final String finalFileName = fileName ?? _generateFileName();
      final Reference ref = _storage
          .ref()
          .child(FirebaseConstants.postsStoragePath)
          .child(finalFileName);
      
      final UploadTask uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: _getContentType(file.path),
          customMetadata: {
            'uploadedAt': DateTime.now().toIso8601String(),
            'type': 'post_image',
          },
        ),
      );

      // 진행률 모니터링
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleStorageException(e);
    } catch (e) {
      throw '이미지 업로드에 실패했습니다: ${e.toString()}';
    }
  }

  /// 프로필 이미지 업로드
  /// [file] 업로드할 파일
  /// [userId] 사용자 ID
  /// 반환값: 다운로드 URL
  Future<String> uploadProfileImage(File file, String userId) async {
    try {
      final String fileName = 'profile_$userId.${_getFileExtension(file.path)}';
      final Reference ref = _storage
          .ref()
          .child(FirebaseConstants.profileImagesPath)
          .child(fileName);
      
      final UploadTask uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: _getContentType(file.path),
          customMetadata: {
            'uploadedAt': DateTime.now().toIso8601String(),
            'userId': userId,
            'type': 'profile_image',
          },
        ),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleStorageException(e);
    } catch (e) {
      throw '프로필 이미지 업로드에 실패했습니다: ${e.toString()}';
    }
  }

  /// 이미지 삭제
  /// [url] 삭제할 이미지의 다운로드 URL
  Future<void> deleteImage(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleStorageException(e);
    } catch (e) {
      throw '이미지 삭제에 실패했습니다: ${e.toString()}';
    }
  }

  /// 여러 이미지 삭제
  /// [urls] 삭제할 이미지 URL 리스트
  Future<void> deleteImages(List<String> urls) async {
    if (urls.isEmpty) return;
    
    try {
      final List<Future<void>> deleteTasks = urls.map((url) {
        return deleteImage(url);
      }).toList();
      
      await Future.wait(deleteTasks);
    } catch (e) {
      throw '이미지 삭제에 실패했습니다: ${e.toString()}';
    }
  }

  /// 이미지 메타데이터 가져오기
  /// [url] 이미지 다운로드 URL
  /// 반환값: 메타데이터
  Future<FullMetadata> getImageMetadata(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      return await ref.getMetadata();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleStorageException(e);
    } catch (e) {
      throw '이미지 정보를 가져오는데 실패했습니다: ${e.toString()}';
    }
  }

  /// 파일명 자동 생성
  String _generateFileName() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'image_$timestamp.jpg';
  }

  /// 파일 확장자 추출
  String _getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  /// Content-Type 결정
  String _getContentType(String filePath) {
    final extension = _getFileExtension(filePath);
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      default:
        return 'application/octet-stream';
    }
  }

  /// 파일 크기 확인
  bool isFileSizeValid(File file, {int maxSizeInMB = 10}) {
    final fileSizeInBytes = file.lengthSync();
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024; // MB to bytes
    return fileSizeInBytes <= maxSizeInBytes;
  }

  /// 이미지 파일 형식 확인
  bool isImageFile(String filePath) {
    final extension = _getFileExtension(filePath);
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  /// 비디오 파일 형식 확인
  bool isVideoFile(String filePath) {
    final extension = _getFileExtension(filePath);
    return ['mp4', 'mov', 'avi'].contains(extension);
  }
}

// Riverpod Provider
@Riverpod(keepAlive: true)
StorageService storageService(Ref ref) {
  return StorageService();
}