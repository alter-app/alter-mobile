import 'package:alter/common/util/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> loginWithKakao() async {
    OAuthToken oAuthToken;
    // 카카오톡 실행 가능 여부 확인
    if (await isKakaoTalkInstalled()) {
      try {
        oAuthToken = await UserApi.instance.loginWithKakaoTalk();
        Log.d(
          "kakaoTalk login accessToken: ${oAuthToken.accessToken.toString()}",
        );
      } catch (e) {
        Log.w("kakaoTalk login failed: $e");
        if (e is PlatformException && e.code == "CANCELED") {
          // 로그인 취소
          return false;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          oAuthToken = await UserApi.instance.loginWithKakaoAccount();
          Log.d(
            "kakaoAccount login accessToken: ${oAuthToken.accessToken.toString()}",
          );
        } catch (e) {
          Log.e("kakaoAccount login failed: $e");
          // 로그인 실패
          return false;
        }
      }
    } else {
      // 카카오톡 어플이 설치되지 않은 경우
      try {
        oAuthToken = await UserApi.instance.loginWithKakaoAccount();
        Log.d(
          "kakaoAccount login accessToken: ${oAuthToken.accessToken.toString()}",
        );
      } catch (e) {
        Log.e("kakaoAccount login failed: $e");
        // 로그인 실패
        return false;
      }
    }
    await _storage.write(
      key: "kakao_access_token",
      value: oAuthToken.accessToken,
    );
    return true;
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'kakao_access_token');
  }
}
