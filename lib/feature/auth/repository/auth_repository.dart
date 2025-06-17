import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/model/auth_model.dart';
import 'package:alter/feature/auth/model/login_request_model.dart';
import 'package:alter/feature/auth/model/login_response_model.dart';
import 'package:alter/feature/auth/model/signup_request_model.dart';
import 'package:alter/feature/auth/service/auth_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.watch(authApiProvider)),
);

class AuthRepository {
  final AuthApiClient authApi;

  AuthRepository(this.authApi);

  Future<Result<LoginResponse>> kakaoLogin(Role role) async {
    final kakaoToken = await _kakaoLoginAuthenticate();
    if (kakaoToken == null) {
      return Result.failure(Exception("카카오 로그인 실패"));
    }
    final accessToken = kakaoToken.accessToken;
    final body = LoginRequest(
      provider: "KAKAO",
      accessToken: accessToken,
      authorizationCode: "",
    );
    try {
      final httpResponse = switch (role) {
        Role.user || Role.guest => await authApi.login(body),
        Role.manager => await authApi.managerLogin(body),
      };

      final status = httpResponse.response.statusCode;
      final response = httpResponse.data;
      Log.d("[$status] response: $response");

      return Result.success(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final status = e.response?.statusCode;
        final errorResponse = e.response?.data;
        Log.e("[$status] error: $errorResponse");

        return Result.process(e);
      } else {
        // TODO 연결 시간 초과 등 다른 오류 추후 커스텀 예외 처리 필요
        return Result.failure(Exception("Kakao login API failed"));
      }
    } catch (e) {
      Log.e("Kakao login API failed: $e");
      return Result.failure(Exception("Kakao login API failed"));
    }
  }

  Future<OAuthToken?> _kakaoLoginAuthenticate() async {
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

  Future<Result<bool>> checkNickname(String nickname) async {
    try {
      final response = await authApi.checkNickname(
        NicknameCheckRequest(nickname: nickname),
      );
      final status = response.response.statusCode;
      final data = response.data["data"];
      final isDuplicated = data["duplicated"];
      Log.d("[$status] isDuplicated: $isDuplicated");
      return Result.success(isDuplicated);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final status = e.response?.statusCode;
        final errorResponse = e.response?.data;
        Log.e("[$status] error: $errorResponse");
        return Result.failure(e);
      }
      return Result.failure(e);
    } catch (e) {
      Log.e("Check nickname API failed: $e");
      return Result.failure(e as Exception);
    }
  }

  Future<Result<LoginResponse>> signUp(SignupRequest request) async {
    try {
      final httpResponse = await authApi.signup(request);
      final response = httpResponse.data;
      Log.d("sign up success: $response");
      return Result.success(response.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final errorResponse = e.response?.data;
      Log.e("[$status] error: $errorResponse");

      return Result.process(e);
    } catch (e) {
      Log.e("Sign up failed : $e");
      return Result.failure(Exception("회원가입 실패"));
    }
  }
}
