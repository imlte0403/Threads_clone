import 'package:flutter/material.dart';

class AppTextStyles {
  // 유저네임
  static const TextStyle username = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 기본 텍스트
  static const TextStyle commonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  // 시스템 메시지
  static const TextStyle system = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  // 사용자 소개
  static const TextStyle userIntroduction = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  // === 활동 화면 스타일들 ===
  // 화면 제목
  static const TextStyle screenTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 활동 내용
  static TextStyle activityContent = TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
  );

  // Following 버튼
  static TextStyle followingButton = TextStyle(
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // 탭 선택됨
  static const TextStyle tabSelected = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // 탭 선택안됨
  static const TextStyle tabUnselected = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
