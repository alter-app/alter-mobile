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
      backgroundColor: AppColor.white,
      foregroundColor: AppColor.text,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColor.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColor.text,
      unselectedItemColor: AppColor.gray[30],
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none,
        ),
        //padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
        foregroundColor: AppColor.text,
        textStyle: const TextStyle(fontSize: 16),
        minimumSize: const Size(64, 50),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.gray[10]!,
      helperStyle: const TextStyle(
        color: AppColor.primary,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.5,
        letterSpacing: -1.0,
      ),
      hintStyle: TextStyle(
        color: AppColor.gray[40],
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
      errorStyle: const TextStyle(
        color: AppColor.warning,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.5,
        letterSpacing: -1.0,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      // 기본 입력폼
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: WidgetStateColor.fromMap({
            WidgetState.error: AppColor.warning,
            WidgetState.focused: Colors.blue,
            WidgetState.any: AppColor.primary,
          }),
        ),
      ),
      // 입력 가능 폼
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColor.gray[10]!, width: 0.5),
      ),
      // 포커스 폼
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      // 에러 폼
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.warning, width: 0.5),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColor.primary, // 메인 컬러로 설정
      linearTrackColor: AppColor.gray, // 배경 트랙 컬러
      circularTrackColor: AppColor.gray, // 원형 배경 트랙 컬러
      refreshBackgroundColor: AppColor.white, // RefreshIndicator 배경
      linearMinHeight: 4.0, // 선형 인디케이터 높이
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      checkColor: const WidgetStateColor.fromMap({
        WidgetState.any: AppColor.white,
      }),
      fillColor: WidgetStateColor.fromMap({
        WidgetState.selected: AppColor.primary,
        WidgetState.any: AppColor.gray[20]!,
      }),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.fromMap({
        WidgetState.selected: AppColor.primary,
        WidgetState.any: AppColor.gray[20]!,
      }),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.5,
        letterSpacing: -1.0,
        color: AppColor.text,
      ),
      contentTextStyle: const TextStyle(
        fontSize: 16,
        height: 1.5,
        letterSpacing: -1.0,
        color: AppColor.text,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      indicatorColor: AppColor.primary,
      labelColor: AppColor.primary,
      unselectedLabelColor: AppColor.gray,
      labelStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: -1.0,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
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
  static const Color secondary = Color(0xFF399982);
  static const Color text = Color(0xFF111111);
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
