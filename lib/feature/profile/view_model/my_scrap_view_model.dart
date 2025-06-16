import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/home/repository/posting_repository.dart';
import 'package:alter/feature/home/view_model/scrap_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:alter/feature/home/model/posting_response_model.dart'; // Posting 모델 재사용

part 'my_scrap_view_model.freezed.dart';

@freezed
abstract class MyScrapListState with _$MyScrapListState {
  const factory MyScrapListState({
    @Default(AsyncValue.loading())
    AsyncValue<List<Scrap>> scrappedPostings, // 스크랩된 게시글 리스트
    String? cursor,
    @Default(false) bool hasMore,
  }) = _MyScrapListState;
}

final myScrapListViewModelProvider =
    NotifierProvider<MyScrapListViewModel, MyScrapListState>(
      () => MyScrapListViewModel(),
    );

class MyScrapListViewModel extends Notifier<MyScrapListState> {
  PostingRepository get _postingRepository =>
      ref.watch(postingRepositoryProvider);

  String? get _accessToken {
    final loginState = ref.watch(loginViewModelProvider);
    return loginState.token?.accessToken;
  }

  @override
  MyScrapListState build() {
    return const MyScrapListState();
  }

  /// 초기 스크랩 리스트를 가져옵니다.
  Future<void> fetchInitialScraps() async {
    Log.d("MyScrapListViewModel: fetchInitialScraps 호출");
    final token = _accessToken;
    if (token == null) {
      state = state.copyWith(
        scrappedPostings: AsyncValue.error("로그인이 필요합니다", StackTrace.current),
      );
      return;
    }

    if (state.scrappedPostings.value == null ||
        state.scrappedPostings.hasError) {
      state = state.copyWith(scrappedPostings: const AsyncValue.loading());
    }
    final result = await _postingRepository.getScraps(token, null);

    switch (result) {
      case Success(data: final data):
        // 스크랩 상태 맵 업데이트
        final Map<int, bool> initialScrapStatuses = {};
        for (var scrap in data.data) {
          initialScrapStatuses[scrap.id] = true;
        }
        ref
            .read(scrapStatusNotifierProvider.notifier)
            .setScrapStatuses(initialScrapStatuses);

        state = state.copyWith(
          scrappedPostings: AsyncValue.data(data.data),
          cursor: data.page.cursor,
          hasMore: data.data.isNotEmpty,
        );
        Log.d("MyScrapListViewModel: 초기 스크랩 로드 성공. ${data.data.length}개");
        break;
      case Failure(error: final error):
        state = state.copyWith(
          scrappedPostings: AsyncValue.error(error, StackTrace.current),
        );
        Log.e("MyScrapListViewModel: 초기 스크랩 로드 실패: $error");
        break;
    }
  }

  /// 다음 페이지의 스크랩 리스트를 가져옵니다 (무한 스크롤).
  Future<void> fetchNextScraps() async {
    // 이미 로딩 중이거나 더 이상 데이터가 없거나 커서가 없으면 요청하지 않음
    if (state.scrappedPostings.isLoading ||
        !state.hasMore ||
        state.cursor == null) {
      return;
    }

    final token = _accessToken;
    if (token == null) return;

    final currentPostings = state.scrappedPostings.value ?? [];
    // 새로운 로딩 상태를 설정하되, 기존 데이터를 유지 (스크롤 중 로딩 UI를 위해)
    state = state.copyWith(
      scrappedPostings: AsyncValue.data(currentPostings),
    ); // UI에 기존 데이터 표시 유지

    final result = await _postingRepository.getScraps(token, state.cursor);

    switch (result) {
      case Success(data: final data):
        final newData = data.data;
        final updatedPostings = [...currentPostings, ...newData];

        // 새로 가져온 데이터의 스크랩 상태도 전역 맵에 업데이트
        final Map<int, bool> newScrapStatuses = {};
        for (var posting in newData) {
          newScrapStatuses[posting.id] = true;
        }
        ref
            .read(scrapStatusNotifierProvider.notifier)
            .setScrapStatuses(newScrapStatuses);

        state = state.copyWith(
          scrappedPostings: AsyncValue.data(updatedPostings),
          cursor: data.page.cursor,
          hasMore: newData.isNotEmpty, // 새로 가져온 데이터가 없으면 끝
        );
        Log.d("MyScrapListViewModel: 다음 스크랩 로드 성공. ${newData.length}개 추가.");
        break;
      case Failure(error: final error):
        // 다음 페이지 로드 실패 시, 에러 상태로 변경
        state = state.copyWith(
          scrappedPostings: AsyncValue.error(error, StackTrace.current),
        );
        Log.e("MyScrapListViewModel: 다음 스크랩 로드 실패: $error");
        break;
    }
  }

  /// 스크랩 리스트를 새로고침합니다 (당겨서 새로고침).
  Future<void> refreshScraps() async {
    Log.d("MyScrapListViewModel: refreshScraps 호출");
    state = state.copyWith(cursor: null, hasMore: false); // 커서 초기화
    await fetchInitialScraps(); // 초기 데이터 다시 가져오기
  }

  /// UI에서 스크랩 해제 시 호출될 메서드
  /// 낙관적 업데이트를 통해 UI에서 즉시 제거하고, API 호출 실패 시 롤백합니다.
  Future<void> removeScrapFromList(int postId) async {
    // 1. 낙관적 업데이트: UI에서 해당 아이템 즉시 제거
    final currentList = state.scrappedPostings.value ?? [];
    final updatedList = currentList.where((p) => p.id != postId).toList();
    state = state.copyWith(scrappedPostings: AsyncValue.data(updatedList));
    Log.d("postId $postId 리스트에서 낙관적 제거 시도");

    // 2. 실제 API 호출 (기존 ScrapViewModel의 toggleScrap 재사용)
    // toggleScrap은 내부적으로 상태 롤백 로직을 가지고 있음
    final success = await ref
        .read(scrapStatusNotifierProvider.notifier)
        .toggleScrap(postId);

    if (!success) {
      // API 실패 시: ScrapViewModel에서 롤백이 일어났으므로,
      // MyScrapListViewModel도 동기화를 위해 전체를 새로고침하는 것이 가장 안전합니다.
      Log.w("스크랩 해제 실패, MyScrapListViewModel 리스트 새로고침 시도");
      await refreshScraps();
    } else {
      Log.d("스크랩 해제 성공 (API), 리스트에서 제거 완료.");
    }
  }
}
