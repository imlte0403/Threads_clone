
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:thread_clone/features/write/write_screen.dart';
import 'package:thread_clone/widgets/navigation_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',

    // 전역 리다이렉션 로직 제거 (문제 해결)
    redirect: null,

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

      // Write 라우트 (로그인한 사용자만 접근 가능)
      GoRoute(
        path: '/write',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const WriteScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
        ),
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
});

GoRouter createRouter({required WidgetRef ref}) {
  return ref.watch(_routerProvider);
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
