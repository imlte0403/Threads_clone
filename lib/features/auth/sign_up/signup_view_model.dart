import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/auth_repository.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  // UI 상태 관리
  bool _isLoading = false;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  User? _user;
  bool _agreedToTerms = false;

  // 생성자
  SignUpViewModel({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  User? get user => _user;
  bool get isSignedUp => _user != null;
  bool get agreedToTerms => _agreedToTerms;

  // ==================== 회원가입 메인 로직 ====================

  /// 이메일과 비밀번호로 회원가입
  Future<bool> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // 초기화
    _clearErrors();

    // 유효성 검사
    if (!_validateSignUpForm(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    )) {
      return false;
    }

    // 약관 동의 확인
    if (!_agreedToTerms) {
      _setError('서비스 약관에 동의해주세요');
      return false;
    }

    // 로딩 시작
    _setLoading(true);

    try {
      _user = await _authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 회원가입 성공 
      _setLoading(false);
      return true;
    } catch (e) {
      // 회원가입 실패
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== 폼 검증 ====================

  /// 회원가입 폼 유효성 검사
  bool _validateSignUpForm({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    bool isValid = true;

    // 이메일 검증
    if (email.isEmpty) {
      _emailError = '이메일을 입력해주세요';
      isValid = false;
    } else if (!_authRepository.isValidEmail(email)) {
      _emailError = '올바른 이메일 형식이 아닙니다';
      isValid = false;
    }

    // 비밀번호 검증
    if (password.isEmpty) {
      _passwordError = '비밀번호를 입력해주세요';
      isValid = false;
    } else if (password.length < 6) {
      _passwordError = '비밀번호는 6자 이상이어야 합니다';
      isValid = false;
    }

    // 비밀번호 확인 검증
    if (confirmPassword.isEmpty) {
      _confirmPasswordError = '비밀번호를 다시 입력해주세요';
      isValid = false;
    } else if (password != confirmPassword) {
      _confirmPasswordError = '비밀번호가 일치하지 않습니다';
      isValid = false;
    }

    if (!isValid) {
      notifyListeners();
    }

    return isValid;
  }

  /// 이메일 형식 검증 
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return null; 
    }

    if (!_authRepository.isValidEmail(email)) {
      return '올바른 이메일 형식이 아닙니다';
    }

    return null;
  }

  /// 비밀번호 형식 검증
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return null; 
    }

    if (password.length < 6) {
      return '비밀번호는 6자 이상이어야 합니다';
    }

    return null;
  }

  /// 비밀번호 확인 검증 
  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return null; 
    }

    if (password != confirmPassword) {
      return '비밀번호가 일치하지 않습니다';
    }

    return null;
  }

  // ==================== 약관 동의 ====================

  /// 약관 동의 상태 변경
  void setAgreedToTerms(bool value) {
    _agreedToTerms = value;
    notifyListeners();
  }

  // ==================== 에러 및 상태 관리 ====================

  /// 로딩 상태 설정
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 에러 메시지 설정
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// 모든 에러 초기화
  void _clearErrors() {
    _errorMessage = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    notifyListeners();
  }

    /// 에러 메시지 클리어
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// 이메일 에러 클리어
  void clearEmailError() {
    _emailError = null;
    notifyListeners();
  }

  /// 비밀번호 에러 클리어
  void clearPasswordError() {
    _passwordError = null;
    notifyListeners();
  }

  /// 비밀번호 확인 에러 클리어
  void clearConfirmPasswordError() {
    _confirmPasswordError = null;
    notifyListeners();
  }

  // ==================== 디스포즈 ====================

  @override
  void dispose() {
    _clearErrors();
    super.dispose();
  }
}
