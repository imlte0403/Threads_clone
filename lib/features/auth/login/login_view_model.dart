
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/auth_repository.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    
    final authRepository = ref.read(authRepositoryProvider);
    
    try {
      await authRepository.signIn(
        email: email,
        password: password,
      );
      
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  String? validateEmail(String email) {
    final authRepository = ref.read(authRepositoryProvider);
    if (email.isEmpty) {
      return null; 
    }
    
    if (!authRepository.isValidEmail(email)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    
    return null;
  }

  String? validatePassword(String password) {
    final authRepository = ref.read(authRepositoryProvider);
    if (password.isEmpty) {
      return null; 
    }
    
    if (!authRepository.isValidPassword(password)) {
      return '비밀번호는 6자 이상이어야 합니다';
    }
    
    return null;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    
    final authRepository = ref.read(authRepositoryProvider);
    
    try {
      await authRepository.signOut();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}