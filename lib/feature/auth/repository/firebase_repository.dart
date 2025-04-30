import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseRepositoryProvider = Provider<FirebaseRepository>(
  (ref) => FirebaseRepository(),
);

class FirebaseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    required Function(String phoneNumber) onVerified,
  }) async {
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        // android에서 자동 인증이 완료되면 호출
        Log.d("verification completed");
        _auth.signInWithCredential(phoneAuthCredential);
        onVerified(phoneNumber);
      },
      verificationFailed: (error) {
        onError(error.message ?? "인증 실패");
      },
      codeSent: (verificationId, forceResendingToken) {
        // resendToken android에서만 지원 ios는 null 반환
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<Result<String>> signInwithCode({
    required String verificationId,
    required String code,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      final user = await _auth.signInWithCredential(credential);
      Log.d("user : ${user.credential.toString()}");
      return const Result.success("인증 성공");
    } catch (e) {
      return Result.failure(e as Exception);
    }
  }
}
