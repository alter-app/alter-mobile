import 'package:alter/common/theme/app_theme.dart';
import 'package:alter/common/util/logger.dart';
import 'package:alter/core/env.dart';
import 'package:alter/core/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting('ko_KR', null);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setLanguageCode('ko');

  // Initialize Kakao SDK
  KakaoSdk.init(nativeAppKey: Env.kakaoAppKey);

  await FlutterNaverMap().init(
    clientId: Env.naverClientId,
    onAuthFailed: (ex) {
      // 인증 실패 처리
      Log.e("네이버 지도 인증 실패");
    },
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "ALTER",
      theme: AppTheme.lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
