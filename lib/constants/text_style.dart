import 'package:flutter/material.dart';

class AppTextStyles {
  // 유저네임
  static const TextStyle username = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // 게시물 텍스트
  static const TextStyle postText = TextStyle(
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
}