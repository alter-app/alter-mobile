import 'package:alter/feature/auth/model/login_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

// 로그인 요청 모델

@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String provider,
    ServiceToken? oauthToken,
    String? authorizationCode,
    @Default("NATIVE") String platformType,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
