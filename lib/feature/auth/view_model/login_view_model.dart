import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/repository/auth_repository.dart';
import 'package:alter/feature/auth/model/login_response_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_view_model.freezed.dart';

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  () => LoginViewModel(),
);

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = LoginInitial;
  const factory LoginState.loading() = LoginLoading;
  const factory LoginState.success(ServiceToken token) = LoginSuccess;
  const factory LoginState.signupRequired(SignupRequiredData data) =
      LoginSignupRequired;
  const factory LoginState.tokenExpired() = LoginTokenExpired;
  const factory LoginState.fail(String message) = LoginFail;
}

class LoginViewModel extends Notifier<LoginState> {
  AuthRepository get _repository => ref.watch(authRepositoryProvider);

  @override
  LoginState build() {
    return const LoginState.initial();
  }

  Future<void> loginWithKakao() async {
    state = const LoginState.loading();
    Result<LoginResponse> result = await _repository.kakaoLogin();
    switch (result) {
      case Success(data: final data):
        Log.d("성공: $data");
        final token = ServiceToken(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        state = LoginState.success(token);
      case Process(error: final error):
        final res = error.response!;
        Log.d("처리 필요: ${res.data}");
        final data = LoginFailure.fromJson(res.data);
        final code = data.code;
        if (code == "A003") {
          state = LoginState.signupRequired(data.data!);
        } else if (code == "A004") {
          state = const LoginState.fail("중복된 이메일 주소입니다. 다른 소셜 로그인을 이용해 주세요.");
        } else if (code == "A007") {
          state = const LoginState.tokenExpired();
        } else {
          state = const LoginState.fail("로그인 실패");
        }
      case Failure(error: final error):
        Log.d("실패: ${error.toString()}");
        state = const LoginState.fail("로그인 실패");
    }
  }
}
