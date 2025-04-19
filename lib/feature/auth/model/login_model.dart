import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';
// 로그인 요청 모델

@freezed
abstract class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({
    required String provider,
    required String accessToken,
    required String authorizationCode,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
}

// 로그인 응답 모델
@freezed
abstract class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    required String accessToken,
    required String refreshToken,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}
