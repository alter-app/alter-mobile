import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/profile/model/profile_request_model.dart';
import 'package:alter/feature/profile/model/profile_response_model.dart';
import 'package:alter/feature/profile/repository/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final certificateViewModelProvider =
    AsyncNotifierProvider<CertificateViewModel, List<Certificate>>(
      CertificateViewModel.new,
    );

class CertificateViewModel extends AsyncNotifier<List<Certificate>> {
  ProfileRepository get _profileRepository =>
      ref.read(profileRepositoryProvider);

  String? get _accessToken {
    final loginState = ref.read(loginViewModelProvider);
    return loginState.token?.accessToken;
  }

  @override
  Future<List<Certificate>> build() async {
    // ViewModel이 처음 빌드될 때 자격증 목록을 가져옵니다.
    // 이는 MyPage의 '자격증' 탭이 처음 선택될 때 트리거될 수 있습니다.
    return fetchCertificates();
  }

  /// 자격증 목록을 서버에서 가져옵니다.
  Future<List<Certificate>> fetchCertificates() async {
    final token = _accessToken;
    if (token == null) {
      Log.e("fetchCertificates: Access Token이 없습니다. 로그인 필요.");
      state = AsyncValue.error("로그인이 필요합니다.", StackTrace.current);
      return [];
    }
    if (state.value == null || state.hasError) {
      state = const AsyncValue.loading();
    }
    final result = await _profileRepository.getcertificates(token);

    switch (result) {
      case Success(data: final certificates):
        Log.d("자격증 목록 로드 성공: ${certificates.length}개");
        state = AsyncValue.data(certificates); // 성공 시 데이터 업데이트
        return certificates;
      case Failure(error: final error):
        Log.e("자격증 목록 로드 실패: $error");
        state = AsyncValue.error(error, StackTrace.current);
        throw error;
      default:
        final error = Exception("알 수 없는 에러가 발생했습니다.");
        Log.e("자격증 목록 로드 실패: 알 수 없는 에러");
        state = AsyncValue.error(error, StackTrace.current);
        throw error;
    }
  }

  // TODO: 추후 에러 핸들링을 통해 피드백 해줄 필요 있음
  Future<bool> addCertificate(CertificateRequest newCertificate) async {
    final token = _accessToken;
    if (token == null) {
      Log.e("addCertificate: Access Token이 없습니다. 로그인 필요.");
      return false;
    }

    state = const AsyncValue.loading();

    final result = await _profileRepository.addCertificate(
      token,
      newCertificate,
    );

    switch (result) {
      case Success():
        Log.d("자격증 등록 성공.");
        await fetchCertificates();
        return true;
      case Failure(error: final error):
        Log.e("자격증 등록 실패: $error");
        if (state.value != null) {
          state = AsyncValue.data(state.value!);
        } else {
          state = AsyncValue.error(error, StackTrace.current);
        }
        return false;
      default:
        Log.e("자격증 등록 실패: 알 수 없는 에러");
        if (state.value != null) {
          state = AsyncValue.data(state.value!);
        } else {
          state = AsyncValue.error(
            Exception("알 수 없는 에러가 발생했습니다."),
            StackTrace.current,
          );
        }
        return false;
    }
  }

  Future<bool> updateCertificate(
    CertificateRequest updatedCertificate,
    int id,
  ) async {
    final token = _accessToken;
    if (token == null) {
      Log.e("updateCertificate: Access Token이 없습니다. 로그인 필요.");
      return false;
    }

    state = const AsyncValue.loading();

    final result = await _profileRepository.updateCertificate(
      token,
      id,
      updatedCertificate,
    );

    switch (result) {
      case Success():
        Log.d("자격증 수정 성공.");
        await fetchCertificates();
        return true;
      case Failure(error: final error):
        Log.e("자격증 수정 실패: $error");
        if (state.value != null) {
          state = AsyncValue.data(state.value!);
        } else {
          state = AsyncValue.error(error, StackTrace.current);
        }
        return false;
      default:
        Log.e("자격증 등록 실패: 알 수 없는 에러");
        if (state.value != null) {
          state = AsyncValue.data(state.value!);
        } else {
          state = AsyncValue.error(
            Exception("알 수 없는 에러가 발생했습니다."),
            StackTrace.current,
          );
        }
        return false;
    }
  }

  /// 자격증을 삭제합니다.
  Future<bool> deleteCertificate(int certificateId) async {
    final token = _accessToken;
    if (token == null) {
      Log.e("deleteCertificate: Access Token이 없습니다. 로그인 필요.");
      return false;
    }

    state = const AsyncValue.loading();

    final result = await _profileRepository.deleteCertificate(
      token,
      certificateId,
    );

    switch (result) {
      case Success():
        Log.d("자격증 삭제 성공.");
        await fetchCertificates(); // 목록 새로고침
        return true;
      case Failure(error: final error):
        Log.e("자격증 삭제 실패: $error");
        if (state.value != null) {
          state = AsyncValue.data(state.value!);
        } else {
          state = AsyncValue.error(error, StackTrace.current);
        }
        return false;
      default:
        Log.e("자격증 삭제 실패: 알 수 없는 에러");
        if (state.value != null) {
          state = AsyncValue.data(state.value!);
        } else {
          state = AsyncValue.error(
            Exception("알 수 없는 에러가 발생했습니다."),
            StackTrace.current,
          );
        }
        return false;
    }
  }
}
