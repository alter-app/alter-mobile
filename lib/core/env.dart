import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'KAKAO_NATIVE_APP_KEY', obfuscate: true)
  static String kakaoAppKey = _Env.kakaoAppKey;
}
