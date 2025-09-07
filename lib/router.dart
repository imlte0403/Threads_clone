import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/sizes.dart';
import 'constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:thread_clone/features/home/home.dart';
import 'package:thread_clone/features/search/search_screen.dart';
import 'package:thread_clone/features/activity/activity_screen.dart';
import 'package:thread_clone/features/profile/profile_screen.dart';
import 'package:thread_clone/features/settings/settings_screen.dart';
import 'package:thread_clone/features/settings/privacy_screen.dart';
import 'package:thread_clone/features/auth/login/login_screen.dart';
import 'package:thread_clone/features/auth/sign_up/signup_screen.dart';
import 'package:thread_clone/features/auth/repository/auth_repository.dart';
import 'package:thread_clone/widgets/navigation_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// 인증 상태에 따라 라우터를 생성하는 함수
///
/// [authRepository] AuthRepository 인스턴스
/// [isLoggedIn] 현재 로그인 상태
GoRouter createRouter({
  required AuthRepository authRepository,
  required bool isLoggedIn,
}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',

    // 전역 리다이렉션 로직
    redirect: (BuildContext context, GoRouterState state) {
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToSignUp = state.matchedLocation == '/signup';
      final isAuthRoute = isGoingToLogin || isGoingToSignUp;

      // 로그인되지 않은 상태
      if (!isLoggedIn) {
        // 인증 화면으로 가고 있지 않다면 로그인 화면으로 리다이렉션
        if (!isAuthRoute) {
          return '/login';
        }
        // 이미 인증 화면으로 가고 있다면 그대로 진행
        return null;
      }

      // 로그인된 상태
      if (isLoggedIn) {
        // 인증 화면으로 가려고 한다면 홈으로 리다이렉션
        if (isAuthRoute) {
          return '/';
        }
        // 다른 화면으로 가고 있다면 그대로 진행
        return null;
      }

      return null;
    },

    // 에러 처리
    errorBuilder: (context, state) => const ErrorScreen(),

    routes: [
      // 인증 라우트 (로그인하지 않은 사용자만 접근 가능)
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      // 메인 네비게이션 (로그인한 사용자만 접근 가능)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activity',
                builder: (context, state) => const ActivityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Settings 라우트 (로그인한 사용자만 접근 가능)
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'privacy',
            builder: (context, state) => const PrivacyScreen(),
          ),
        ],
      ),
    ],
  );
}

/// 에러 화면
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.systemBackground(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: Sizes.size64, color: Colors.red),
            const SizedBox(height: Sizes.size16),
            Text(
              '페이지를 찾을 수 없습니다',
              style: AppTextStyles.commonText(
                context,
              ).copyWith(fontSize: Sizes.size18),
            ),
            const SizedBox(height: Sizes.size16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent(context),
                foregroundColor: Colors.white,
              ),
              child: const Text('홈으로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}
