import 'package:flutter/material.dart';
import 'widgets/navigation_bar.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dev/dev_seed.dart';
import 'constants/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 더미 포스트 자동 생성 (개발용)
  await seedPosts(count: 5, repeat: 1);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // 시스템 설정에 따라 자동 전환
      home: const AppNavBar(),
    );
  }
}
