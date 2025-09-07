import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thread_clone/router.dart';
import 'firebase_options.dart';
import 'constants/app_theme.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/auth/login/login_view_model.dart';
import 'features/auth/sign_up/signup_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  try {
    // Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {}

  try {
    // AuthRepository 싱글톤 인스턴스 생성
    final authRepository = AuthRepository();
    runApp(MyApp(authRepository: authRepository));
  } catch (e) {}
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // AuthRepository Provider (싱글톤)
        Provider<AuthRepository>.value(value: authRepository),

        // LoginViewModel Provider
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) =>
              LoginViewModel(authRepository: authRepository)
                ..checkLoginStatus(), // 앱 시작 시 로그인 상태 체크
        ),

        // SignUpViewModel Provider
        ChangeNotifierProvider<SignUpViewModel>(
          create: (context) => SignUpViewModel(authRepository: authRepository),
        ),

        // 인증 상태 스트림 Provider (옵션)
        StreamProvider<bool>(
          create: (context) =>
              authRepository.authStateChanges.map((user) => user != null),
          initialData: false,
        ),
      ],
      child: Consumer2<LoginViewModel, bool>(
        builder: (context, loginViewModel, isLoggedInFromStream, child) {
          // StreamProvider의 인증 상태를 우선적으로 사용
          final isLoggedIn = isLoggedInFromStream || loginViewModel.isLoggedIn;

          return MaterialApp.router(
            routerConfig: createRouter(
              authRepository: authRepository,
              isLoggedIn: isLoggedIn,
            ),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
          );
        },
      ),
    );
  }
}
