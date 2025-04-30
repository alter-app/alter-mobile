import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request_model.freezed.dart';
part 'signup_request_model.g.dart';

// 로그인 요청 모델

@freezed
abstract class SignupRequest with _$SignupRequest {
  const factory SignupRequest({
    required String signupSessionId,
    required String name,
    required String nickname,
    required String contact,
    required String gender,
    required String birthday,
  }) = _SignupRequest;

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);
}

@freezed
abstract class NicknameCheckRequest with _$NicknameCheckRequest {
  const factory NicknameCheckRequest({required String nickname}) =
      _NicknameCheckRequest;

  factory NicknameCheckRequest.fromJson(Map<String, dynamic> json) =>
      _$NicknameCheckRequestFromJson(json);
}
