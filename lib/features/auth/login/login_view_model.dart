import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  // UI 상태 관리
  bool _isLoading = false;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;
  User? _user;

  // 생성자
  LoginViewModel({AuthRepository? authRepository}) 
      : _authRepository = authRepository ?? AuthRepository();

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  // ==================== 로그인 메인 로직 ====================
  
  /// 이메일과 비밀번호로 로그인
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // 초기화
    _clearErrors();
    
    // 유효성 검사
    if (!_validateLoginForm(email: email, password: password)) {
      return false;
    }

    // 로딩 시작
    _setLoading(true);

    try {
      // Firebase 로그인 시도
      _user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // 로그인 성공
      _setLoading(false);
      return true;
      
    } catch (e) {
      // 로그인 실패
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // ==================== 폼 검증 ====================
  
  /// 로그인 폼 유효성 검사
  bool _validateLoginForm({
    required String email,
    required String password,
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


  // ==================== 로그아웃 ====================
  
  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ==================== 자동 로그인 체크 ====================
  
  /// 현재 로그인 상태 확인
  Future<void> checkLoginStatus() async {
    _user = _authRepository.currentUser;
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

  // ==================== 디스포즈 ====================
  
  @override
  void dispose() {
    _clearErrors();
    super.dispose();
  }
}