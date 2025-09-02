import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // 유저네임
  static TextStyle username(BuildContext context) => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.label(context),
  );

  // 기본 텍스트
  static TextStyle commonText(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.label(context),
  );

  // 시스템 메시지
  static TextStyle system(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.tertiaryLabel(context),
  );

  // 사용자 소개
  static TextStyle userIntroduction(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.tertiaryLabel(context),
  );

  // === 활동 화면 스타일들 ===
  // 화면 제목
  static TextStyle screenTitle(BuildContext context) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.label(context),
  );

  // 활동 내용
  static TextStyle activityContent = TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
  );

  // Following 버튼
  static TextStyle followingButton(BuildContext context) => TextStyle(
        color: AppColors.label(context),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  // 탭 선택됨
  static TextStyle tabSelected(BuildContext context) => TextStyle(
        color: AppColors.systemBackground(context),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  // 탭 선택안됨
  static TextStyle tabUnselected(BuildContext context) => TextStyle(
        color: AppColors.label(context),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle settings(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.label(context),
  );

  static const TextStyle logout = TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w600,
  );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.label(context),
  );

  static const TextStyle description = TextStyle(
    fontSize: 12,
    color: Colors.grey,
    height: 1.3,
  );
}
