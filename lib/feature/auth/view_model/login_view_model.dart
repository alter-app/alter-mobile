import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/core/secure_storage_provider.dart';
import 'package:alter/feature/auth/model/auth_model.dart';
import 'package:alter/feature/auth/repository/auth_repository.dart';
import 'package:alter/feature/auth/model/login_response_model.dart';
import 'package:alter/feature/profile/model/profile_response_model.dart';
import 'package:alter/feature/profile/repository/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_view_model.freezed.dart';

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  () => LoginViewModel(),
);

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    required LoginStatus status,
    @Default(Role.guest) Role role,
    ServiceToken? token,
    UserProfile? profile,
    SignupRequiredData? signupData,
    String? message,
  }) = _LoginState;

  factory LoginState.initial() => const LoginState(status: LoginStatus.initial);
}

class LoginViewModel extends Notifier<LoginState> {
  AuthRepository get _repository => ref.watch(authRepositoryProvider);
  ProfileRepository get _profileRepository =>
      ref.watch(profileRepositoryProvider);
  SecureStorage get _storage => ref.watch(secureStorageProvider);

  @override
  LoginState build() {
    return const LoginState(status: LoginStatus.initial);
  }

  Future<void> login(SocialDomain domain) async {
    await _handleSocialLogin(domain, Role.user);
  }

  Future<void> managerLogin(SocialDomain domain) async {
    await _handleSocialLogin(domain, Role.manager);
  }

  Future<void> _handleSocialLogin(SocialDomain domain, Role role) async {
    state = state.copyWith(status: LoginStatus.loading);

    final result = switch (domain) {
      SocialDomain.kakao => await _repository.kakaoLogin(role),
      SocialDomain.apple => await _repository.appleLogin(role),
    };

    switch (result) {
      case Success(data: final data):
        Log.d("성공: $data");
        final token = ServiceToken(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        await _storage.saveToken(token.accessToken, token.refreshToken);
        state = state.copyWith(
          status: LoginStatus.success,
          token: token,
          role: role,
        );
        await getProfile();

      case Process(error: final error):
        final res = error.response!;
        Log.d("처리 필요: ${res.data}");

        final data = LoginFailure.fromJson(res.data);
        final code = data.code;
        if (code == "A003") {
          state = state.copyWith(
            status: LoginStatus.signupRequired,
            signupData: data.data!,
          );
        } else if (code == "A004") {
          state = state.copyWith(
            status: LoginStatus.fail,
            message: "중복된 이메일 주소입니다. 다른 소셜 로그인을 이용해 주세요.",
          );
        } else if (code == "A007") {
          state = state.copyWith(
            status: LoginStatus.tokenExpired,
            message: "로그인이 만료되었습니다. 다시 로그인해주세요",
          );
        } else {
          state = state.copyWith(status: LoginStatus.fail, message: "로그인 실패");
        }
      case Failure(error: final error):
        Log.d("실패: ${error.toString()}");
        state = state.copyWith(status: LoginStatus.fail, message: "로그인 실패");
    }
  }

  Future<void> getProfile() async {
    final token = state.token?.accessToken;
    if (token == null) {
      Log.e("getProfile: Token is Null");
      return;
    }

    final result = await _profileRepository.getProfile(token);

    switch (result) {
      case Success(data: final data):
        state = state.copyWith(profile: data);
    }
  }
}
