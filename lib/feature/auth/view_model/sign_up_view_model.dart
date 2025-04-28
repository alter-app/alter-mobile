import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/model/login_response_model.dart';
import 'package:alter/feature/auth/repository/auth_repository.dart';
import 'package:alter/feature/auth/repository/firebase_repository.dart';
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
    String? birth,
    // firebase
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
      name: "주재석",
    );
  }

  // SignupRequiredData로 상태 초기화
  void initializeWithSignupData(SignupRequiredData data) {
    state = SignupState(
      signupSessionId: data.signupSessionId,
      contact: null,
      name: data.name,
      nickname: null,
      gender: data.gender,
      birth: data.birthday,
      verificationId: null,
      isPhoneAuthSuccess: false,
    );
  }

  void updateField({
    String? name,
    String? nickname,
    String? contact,
    String? gender,
    String? birth,
    String? code,
  }) {
    state = state.copyWith(
      name: name ?? state.name,
      nickname: nickname ?? state.nickname,
      contact: contact ?? state.contact,
      gender: gender ?? state.gender,
      birth: birth ?? state.birth,
      code: code ?? state.code,
    );
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
        state = state.copyWith(verificationId: verificationId, contact: phone);
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
}
