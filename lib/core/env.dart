import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'KAKAO_NATIVE_APP_KEY', obfuscate: true)
  static String kakaoAppKey = _Env.kakaoAppKey;

  @EnviedField(varName: 'NAVER_CLIENT_ID', obfuscate: true)
  static String naverClientId = _Env.naverClientId;

  @EnviedField(varName: 'NAVER_CLIENT_SECRET', obfuscate: true)
  static String naverClientSecret = _Env.naverClientSecret;

  @EnviedField(varName: 'TEST_SERVER_URL')
  static String testServerUrl = _Env.testServerUrl;
}
