import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thread_clone/router.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/app_theme.dart';
import 'features/settings/settings_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(   
    ChangeNotifierProvider(
      create: (context) => SettingsViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<SettingsViewModel>().darkMode 
          ? ThemeMode.dark 
          : ThemeMode.light,
    );
  }
}
