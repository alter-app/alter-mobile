import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

// 로그인 응답 모델
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String authorizationId,
    required String scope,
    required String accessToken,
    required String refreshToken,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
abstract class LoginFailure with _$LoginFailure {
  const factory LoginFailure({
    required String timestamp,
    required String code,
    required String message,
    SignupRequiredData? data,
  }) = _LoginFailure;

  factory LoginFailure.fromJson(Map<String, dynamic> json) =>
      _$LoginFailureFromJson(json);
}

@freezed
abstract class SignupRequiredData with _$SignupRequiredData {
  const factory SignupRequiredData({
    required String signupSessionId,
    String? name,
    String? gender,
    String? birthday,
  }) = _SignupRequiredData;

  factory SignupRequiredData.fromJson(Map<String, dynamic> json) =>
      _$SignupRequiredDataFromJson(json);
}

class ServiceToken {
  final String accessToken;
  final String refreshToken;

  ServiceToken({required this.accessToken, required this.refreshToken});
}
