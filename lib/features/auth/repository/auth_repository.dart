import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthenticationRepository {
  // Firebase Auth 인스턴스
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// 현재 로그인된 사용자 정보
  User? get currentUser => _firebaseAuth.currentUser;

  /// 로그인 여부 확인
  bool get isLoggedIn => currentUser != null;

  /// 인증 상태 변화 스트림
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  // ==================== 회원가입 ====================

  /// 이메일과 비밀번호로 회원가입
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  Future<User?> emailSignUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      throw errorMessage;
    } catch (e) {
      throw '회원가입 중 오류가 발생했습니다. 다시 시도해주세요.';
    }
  }

  // ==================== 로그인 ====================

  /// 이메일과 비밀번호로 로그인
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email.trim(), password: password);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw '로그인 중 오류가 발생했습니다. 다시 시도해주세요.';
    }
  }

  // ==================== 로그아웃 ====================

  /// 현재 사용자 로그아웃
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw '로그아웃 중 오류가 발생했습니다.';
    }
  }

  // ==================== 에러 처리 ====================

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      // 회원가입 에러
      case 'weak-password':
        return '비밀번호가 너무 약합니다. 6자 이상 입력해주세요.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'invalid-email':
        return '유효하지 않은 이메일 형식입니다.';

      // 로그인 에러
      case 'user-not-found':
        return '존재하지 않는 계정입니다.';
      case 'wrong-password':
        return '비밀번호가 올바르지 않습니다.';

      default:
        return e.message ?? '인증 처리 중 오류가 발생했습니다.';
    }
  }

  // ==================== 유틸리티 메서드 ====================

  /// 이메일 형식 검증
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// 비밀번호 강도 검증
  bool isValidPassword(String password) {
    return password.length >= 6;
  }
}

@Riverpod(keepAlive: true)
AuthenticationRepository authRepository(AuthRepositoryRef ref) {
  return AuthenticationRepository();
}

@Riverpod(keepAlive: true)
Stream<bool> authStateStream(AuthStateStreamRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges.map((user) => user != null);
}
