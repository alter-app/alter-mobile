import 'package:alter/core/env.dart';
import 'package:alter/core/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Kakao SDK
  KakaoSdk.init(nativeAppKey: Env.kakaoAppKey);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
