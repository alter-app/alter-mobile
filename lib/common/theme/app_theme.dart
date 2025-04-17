import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Pretendard',
    primaryColor: AppColor.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.white,
      foregroundColor: AppColor.text,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      // 기본 입력폼
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      // 입력 가능 폼
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      // 포커스 폼
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

class AppColor extends Color {
  AppColor(super.value);

  static const Color primary = Color(0xFF2DE283);
  static const Color bg = Color(0xFFF4F4F4);
  static const Color text = Color(0xFF1F2823);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}
