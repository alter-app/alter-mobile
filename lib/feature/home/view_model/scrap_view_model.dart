import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/home/repository/posting_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scrapStatusNotifierProvider =
    NotifierProvider<ScrapViewModel, Map<int, bool>>(ScrapViewModel.new);

class ScrapViewModel extends Notifier<Map<int, bool>> {
  PostingRepository get _postingRepository =>
      ref.watch(postingRepositoryProvider);

  String? get _accessToken {
    final loginState = ref.watch(loginViewModelProvider);
    return loginState.token?.accessToken;
  }

  @override
  build() {
    return {};
  }

  void setScrapStatus(int postId, bool isScrapped) {
    state = {...state, postId: isScrapped};
  }

  void setScrapStatuses(Map<int, bool> newStatuses) {
    state = {...state, ...newStatuses};
  }

  Future<bool> toggleScrap(int postId) async {
    final token = _accessToken;
    if (token == null) {
      Log.e("로그인이 필요합니다.");
      // UI에 메시지를 표시하는 로직 추가
      return false;
    }

    final currentStatus = state[postId] ?? false; // 현재 스크랩 상태
    final newStatus = !currentStatus; // 변경될 상태

    // 낙관적 업데이트: UI를 먼저 업데이트하여 사용자에게 즉각적인 피드백 제공
    state = {...state, postId: newStatus};

    try {
      Result result;
      if (currentStatus) {
        result = await _postingRepository.deleteScrap(token, postId);
      } else {
        result = await _postingRepository.addScrap(token, postId);
      }

      switch (result) {
        case Success():
          Log.d("스크랩 성공 postId: $postId to $newStatus");
          return true;
        case Failure(error: final error):
          // API 실패 시 UI 상태 롤백 (이전 상태로 되돌림)
          state = {...state, postId: currentStatus};
          Log.e(
            "Failed to toggle scrap status for postId: $postId, error: $error",
          );
          // UI에 에러 메시지를 표시하는 로직 추가
          return false;
        default:
          state = {...state, postId: currentStatus};
          return false;
      }
    } catch (e) {
      // 네트워크 에러 등 예외 발생 시 롤백
      state = {...state, postId: currentStatus};
      Log.e("스크랩 중 에러 발생 postId: $postId, error: $e");
      // UI에 에러 메시지를 표시하는 로직 추가
      return false;
    }
  }
}
