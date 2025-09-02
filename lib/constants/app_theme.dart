import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'sizes.dart';

/// 간소화된 앱 테마 시스템
/// 라이트 모드와 다크 모드를 지원하는 핵심 테마만 포함
class AppTheme {
  // ==================== 라이트 테마 ====================

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      
      colorScheme: ColorScheme.light(
        primary: AppColors.lightAccent,
        surface: AppColors.lightSystemBackground,
        onSurface: AppColors.lightLabel,
      ),

      scaffoldBackgroundColor: AppColors.lightSystemBackground,

      // AppBar 테마
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSystemBackground,
        foregroundColor: AppColors.lightLabel,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.lightLabel),
      ),

      // NavigationBar 테마
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSystemBackground,
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.lightLabel
                : AppColors.lightSecondaryLabel,
          ),
        ),
      ),

      // Divider 테마
      dividerTheme: const DividerThemeData(
        color: AppColors.lightSeparator,
        thickness: 0.5,
      ),

      // TextField 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSecondarySystemBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.size10),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.lightTertiaryLabel),
      ),
    );
  }

  // ==================== 다크 테마 ====================

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkAccent,
        surface: AppColors.darkSystemBackground,
        onSurface: AppColors.darkLabel,
      ),

      scaffoldBackgroundColor: AppColors.darkSystemBackground,

      // AppBar 테마
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSystemBackground,
        foregroundColor: AppColors.darkLabel,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.darkLabel),
      ),

      // NavigationBar 테마
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSystemBackground,
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.darkLabel
                : AppColors.lightLabel,
          ),
        ),
      ),

      // Divider 테마
      dividerTheme: const DividerThemeData(
        color: AppColors.darkSeparator,
        thickness: 0.5,
      ),

      // TextField 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSecondarySystemBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.size10),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.lightLabel),
      ),
    );
  }
}