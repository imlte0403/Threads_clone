import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseExceptionHandler {
  
  /// Firestore 예외 처리
  static String handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return '데이터에 접근할 권한이 없습니다.';
      case 'unavailable':
        return '서버에 연결할 수 없습니다. 인터넷 연결을 확인해주세요.';
      case 'deadline-exceeded':
        return '요청 시간이 초과되었습니다. 다시 시도해주세요.';
      case 'resource-exhausted':
        return '요청 한도를 초과했습니다. 잠시 후 다시 시도해주세요.';
      case 'not-found':
        return '요청한 데이터를 찾을 수 없습니다.';
      case 'already-exists':
        return '이미 존재하는 데이터입니다.';
      case 'invalid-argument':
        return '잘못된 요청입니다.';
      case 'failed-precondition':
        return '요청 조건이 맞지 않습니다.';
      case 'out-of-range':
        return '요청 범위를 벗어났습니다.';
      case 'unimplemented':
        return '지원하지 않는 기능입니다.';
      case 'internal':
        return '서버 내부 오류가 발생했습니다.';
      case 'data-loss':
        return '데이터 손실이 발생했습니다.';
      case 'unauthenticated':
        return '인증이 필요합니다.';
      default:
        return e.message ?? '알 수 없는 오류가 발생했습니다.';
    }
  }

  /// Firebase Storage 예외 처리
  static String handleStorageException(FirebaseException e) {
    switch (e.code) {
      case 'storage/object-not-found':
        return '파일을 찾을 수 없습니다.';
      case 'storage/bucket-not-found':
        return '스토리지 버킷을 찾을 수 없습니다.';
      case 'storage/project-not-found':
        return '프로젝트를 찾을 수 없습니다.';
      case 'storage/quota-exceeded':
        return '저장 공간 할당량을 초과했습니다.';
      case 'storage/unauthenticated':
        return '인증이 필요합니다.';
      case 'storage/unauthorized':
        return '파일에 접근할 권한이 없습니다.';
      case 'storage/retry-limit-exceeded':
        return '재시도 횟수를 초과했습니다. 잠시 후 다시 시도해주세요.';
      case 'storage/invalid-checksum':
        return '파일이 손상되었습니다.';
      case 'storage/canceled':
        return '업로드가 취소되었습니다.';
      case 'storage/invalid-event-name':
        return '잘못된 이벤트 이름입니다.';
      case 'storage/invalid-url':
        return '잘못된 URL입니다.';
      case 'storage/invalid-argument':
        return '잘못된 인수입니다.';
      case 'storage/no-default-bucket':
        return '기본 스토리지 버킷이 설정되지 않았습니다.';
      case 'storage/cannot-slice-blob':
        return '파일을 처리할 수 없습니다.';
      case 'storage/server-file-wrong-size':
        return '서버의 파일 크기가 올바르지 않습니다.';
      default:
        return e.message ?? '파일 처리 중 알 수 없는 오류가 발생했습니다.';
    }
  }

  /// 일반적인 예외 처리
  static String handleGenericException(dynamic e) {
    if (e is FirebaseException) {
      if (e.plugin == 'cloud_firestore') {
        return handleFirestoreException(e);
      } else if (e.plugin == 'firebase_storage') {
        return handleStorageException(e);
      }
    }
    
    if (e is Exception) {
      return e.toString().replaceFirst('Exception: ', '');
    }
    
    return e?.toString() ?? '알 수 없는 오류가 발생했습니다.';
  }
}