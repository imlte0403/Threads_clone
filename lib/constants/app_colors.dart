import 'package:flutter/material.dart';

class AppColors {
  // ==================== 라이트 모드 색상 ====================
  /// 주요 텍스트 색상
  static const Color lightLabel = Color(0xFF000000);

  /// 보조 텍스트 색상
  static const Color lightSecondaryLabel = Color(0xFFADB5BD);

  /// 힌트/플레이스홀더 텍스트 색상
  static const Color lightTertiaryLabel = Color(0xFF868E96);

  /// 메인 배경색
  static const Color lightSystemBackground = Color(0xFFFFFFFF);

  /// 보조 배경색 (카드, 입력필드 등)
  static const Color lightSecondarySystemBackground = Color(0xFFF2F2F7);

  /// 구분선 색상
  static const Color lightSeparator = Color(0xffdee2e6);

  /// 링크/액센트 색상
  static const Color lightAccent = Color(0xFF007AFF);

  // ==================== 다크 모드 색상 ====================
  /// 주요 텍스트 색상
  static const Color darkLabel = Color(0xFFFFFFFF);

  /// 보조 텍스트 색상
  static const Color darkSecondaryLabel = Color(0xFFEBEBF5);

  /// 힌트/플레이스홀더 텍스트 색상
  static const Color darkTertiaryLabel = Color(0xFFE9ECEF);

  /// 메인 배경색
  static const Color darkSystemBackground = Color(0xFF000000);

  /// 보조 배경색 (카드, 입력필드 등)
  static const Color darkSecondarySystemBackground = Color(0xFF1C1C1E);

  /// 구분선 색상
  static const Color darkSeparator = Color(0xffa0a0a0);

  /// 링크/액센트 색상
  static const Color darkAccent = Color(0xFF0A84FF);

  // ==================== 동적 색상 메서드 ====================
  /// 주요 텍스트 색상
  static Color label(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkLabel
        : lightLabel;
  }

  /// 보조 텍스트 색상
  static Color secondaryLabel(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondaryLabel
        : lightSecondaryLabel;
  }

  /// 힌트/플레이스홀더 텍스트 색상
  static Color tertiaryLabel(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTertiaryLabel
        : lightTertiaryLabel;
  }

  /// 메인 배경색
  static Color systemBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSystemBackground
        : lightSystemBackground;
  }

  /// 보조 배경색
  static Color secondarySystemBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondarySystemBackground
        : lightSecondarySystemBackground;
  }

  /// 구분선 색상
  static Color separator(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSeparator
        : lightSeparator;
  }

  /// 링크/액센트 색상
  static Color accent(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkAccent
        : lightAccent;
  }

  // ==================== 레거시 호환성 ====================
  static Color quaternaryLabel(BuildContext context) => tertiaryLabel(context);
  static Color link(BuildContext context) => accent(context);
}
