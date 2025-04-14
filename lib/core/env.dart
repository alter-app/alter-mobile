import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'KAKAO_API_KEY')
  static const String kakaoApiKey = _Env.kakaoApiKey;
}
