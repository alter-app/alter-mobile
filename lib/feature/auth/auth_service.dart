import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/model/login_model.dart';
import 'package:alter/feature/auth/service/auth_api.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthService {
  final AuthApiClient authApi;

  AuthService(this.authApi);

  Future<Result<LoginResponseModel, Exception>> kakaoLogin() async {
    final kakaoToken = await kakaoLoginAuthenticate();
    if (kakaoToken == null) {
      return Result.failure(Exception("Kakao login failed"));
    }
    final accessToken = kakaoToken.accessToken;
    Log.d("AccessToken: $accessToken");
    try {
      final response = await authApi.kakaoLogin(
        LoginRequestModel(
          provider: "KAKAO",
          accessToken: accessToken,
          authorizationCode: "",
        ),
      );
      return Result.success(response);
    } catch (e) {
      Log.e("Kakao login API failed: $e");
      return Result.failure(Exception("Kakao login API failed"));
    }
  }

  Future<OAuthToken?> kakaoLoginAuthenticate() async {
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
          return null;
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
          return null;
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
        return null;
      }
    }

    return oAuthToken;
  }
}
