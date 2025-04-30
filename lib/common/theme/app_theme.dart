import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF007AFF),
    ),
    scaffoldBackgroundColor: AppColor.white,
    fontFamily: 'Pretendard',
    textTheme: _textTheme,
    primaryColor: AppColor.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.primary,
      foregroundColor: AppColor.text,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        foregroundColor: AppColor.white,
        backgroundColor: AppColor.primary,
        disabledBackgroundColor: AppColor.gray[30]!,
        textStyle: _textTheme.bodyMedium,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: AppColor.primary, width: 1),
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontSize: 16),
        minimumSize: const Size(64, 50),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.gray[10]!,
      helperStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColor.gray[40],
        height: 1.5,
        letterSpacing: -1.0,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorStyle: const TextStyle(
        color: AppColor.warning,
        fontSize: 12,
        height: 1.5,
        letterSpacing: -1.0,
      ),
      // 기본 입력폼
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      // 입력 가능 폼
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.gray[10]!, width: 1.0),
      ),
      // 포커스 폼
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      hintStyle: TextStyle(
        color: AppColor.gray[40],
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
    ),
  );

  static final TextTheme _textTheme = const TextTheme(
    // Title 1
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.5,
      letterSpacing: -1.0,
    ),
    // Title 2
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.5,
      letterSpacing: -1.0,
    ),
    // Sub Title 1
    displayLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      height: 1.5,
      letterSpacing: -1.0,
    ),
    // Sub Title 2
    displayMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.5,
      letterSpacing: -1.0,
    ),
    // Body 1
    bodyLarge: TextStyle(fontSize: 16, height: 1.5, letterSpacing: -1.0),
    // Body 2
    bodyMedium: TextStyle(fontSize: 14, height: 1.5, letterSpacing: -1.0),
    // Body 3
    bodySmall: TextStyle(fontSize: 12, height: 1.5, letterSpacing: -1.0),
  );
}

class AppColor extends Color {
  AppColor(super.value);

  static const Color primary = Color(0xFF2DE283);
  static const Color text = Color(0xFF1F2823);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color warning = Color(0xFFDC0000);
  static const int _grayPrimaryValue = 0xFF767676;
  static const MaterialColor gray =
      MaterialColor(_grayPrimaryValue, <int, Color>{
        10: Color(0xFFF6F6F6),
        20: Color(0xFFD9D9D9),
        30: Color(0xFFCBCBCB),
        40: Color(0xFF999999),
        50: Color(_grayPrimaryValue),
      });
}
