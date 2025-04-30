import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/model/login_response_model.dart';
import 'package:alter/feature/auth/model/signup_request_model.dart';
import 'package:alter/feature/auth/repository/auth_repository.dart';
import 'package:alter/feature/auth/repository/firebase_repository.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_view_model.freezed.dart';

// initial,

@freezed
abstract class SignupState with _$SignupState {
  factory SignupState({
    required String signupSessionId,
    String? name,
    String? nickname,
    String? contact,
    String? gender,
    String? birthday,
    // firebase
    required bool isPhoneAuthSent,
    required bool isPhoneAuthSuccess,
    String? verificationId,
    String? code,
    String? errorMessage,
  }) = _SignupState;
}

final signUpViewModelProvider = NotifierProvider<SignUpViewModel, SignupState>(
  () => SignUpViewModel(),
);

class SignUpViewModel extends Notifier<SignupState> {
  FirebaseRepository get _firebase => ref.watch(firebaseRepositoryProvider);
  AuthRepository get _authRepository => ref.watch(authRepositoryProvider);

  @override
  build() {
    return SignupState(
      signupSessionId: "",
      isPhoneAuthSuccess: false,
      isPhoneAuthSent: false,
      gender: "GENDER_MALE",
    );
  }

  // SignupRequiredData로 상태 초기화
  void initializeWithSignupData(SignupRequiredData data) {
    state = state.copyWith(
      signupSessionId: data.signupSessionId,
      name: data.name,
      gender: data.gender ?? "GENDER_MALE",
      birthday: data.birthday,
    );
  }

  void updateField({
    String? name,
    String? nickname,
    String? contact,
    String? gender,
    String? birthday,
    String? code,
    String? errorMessage,
    bool? isPhoneAuthSuccess,
  }) {
    state = state.copyWith(
      name: name ?? state.name,
      nickname: nickname ?? state.nickname,
      contact: contact ?? state.contact,
      gender: gender ?? state.gender,
      birthday: birthday ?? state.birthday,
      code: code ?? state.code,
      isPhoneAuthSuccess: isPhoneAuthSuccess ?? state.isPhoneAuthSuccess,
    );
    Log.i("state : ${state.toString()}");
  }

  Future<void> verifyPhoneNumber() async {
    final contact = state.contact;
    if (contact == null || contact.isEmpty) {
      Exception("전화번호가 비어있습니다.");
    }
    final phone = "+82${contact!.substring(1)}";
    await _firebase.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (verificationId) {
        Log.d("code sent");
        state = state.copyWith(
          verificationId: verificationId,
          isPhoneAuthSent: true,
        );
      },
      onError: (error) {
        state = state.copyWith(errorMessage: error);
      },
      // 안드로이드에서 자동 인증 완료시 호출
      onVerified: (phoneNumber) {
        state = state.copyWith(contact: phoneNumber, isPhoneAuthSuccess: true);
      },
    );
  }

  Future<void> signInWithCode() async {
    if (state.verificationId == null || state.code == null) return;

    final result = await _firebase.signInwithCode(
      verificationId: state.verificationId!,
      code: state.code!,
    );
    switch (result) {
      case Success():
        state = state.copyWith(isPhoneAuthSuccess: true);
      default:
        state = state.copyWith(
          isPhoneAuthSuccess: false,
          errorMessage: "인증 실패",
        );
    }
  }

  Future<bool> checkNickname(String nickname) async {
    final result = await _authRepository.checkNickname(nickname);

    switch (result) {
      case Success(data: final isDuplicated):
        if (isDuplicated) {
          state = state.copyWith(errorMessage: "중복된 닉네임입니다.");
          return false;
        } else {
          state = state.copyWith(nickname: nickname);
          return true;
        }
      default:
        state = state.copyWith(errorMessage: "알 수 없는 오류. 다시 시도해 주세요.");
        return false;
    }
  }

  Future<void> signUp() async {
    final result = await _authRepository.signUp(
      SignupRequest(
        signupSessionId: state.signupSessionId,
        name: state.name!,
        nickname: state.nickname!,
        contact: state.contact!,
        gender: state.gender!,
        birthday: state.birthday!,
      ),
    );
    final loginViewModel = ref.read(loginViewModelProvider.notifier);

    switch (result) {
      case Success(data: final data):
        // 예시: 회원가입 성공하면 로그인 성공으로 상태 변경
        final token = ServiceToken(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        loginViewModel.state = LoginState.success(token);
      case Process(error: final error):
        final data = LoginFailure.fromJson(error.response!.data);
        final code = data.code;
        Log.d("code: $code");
        switch (code) {
          case "A003":
            state = state.copyWith(errorMessage: "");
        }
      default:
        loginViewModel.state = const LoginState.fail('회원 가입 실패');
    }
  }
}
