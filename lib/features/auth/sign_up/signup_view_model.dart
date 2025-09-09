
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/auth_repository.dart';

part 'signup_view_model.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    
    final authRepository = ref.read(authRepositoryProvider);
    
    try {
      await authRepository.emailSignUp(
        email: email,
        password: password,
      );
      
      // TODO: userViewModel.createUser를 통해 Firestore에 유저 정보 저장 필요
      
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

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return null; 
    }

    if (password != confirmPassword) {
      return '비밀번호가 일치하지 않습니다';
    }

    return null;
  }
}
