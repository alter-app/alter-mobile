import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/repository/posting_repository.dart';
import 'package:alter/feature/home/view_model/scrap_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'posting_view_model.freezed.dart';

@freezed
abstract class PostingListState with _$PostingListState {
  const factory PostingListState({
    @Default(AsyncValue.loading()) AsyncValue<List<Posting>> postings,
    String? cursor,
    @Default(false) bool hasMore,
  }) = _PostingListState;
}

final postingListViewModelProvider =
    NotifierProvider<PostingListViewModel, PostingListState>(
      () => PostingListViewModel(),
    );

class PostingListViewModel extends Notifier<PostingListState> {
  PostingRepository get _postingRepository =>
      ref.watch(postingRepositoryProvider);

  @override
  PostingListState build() {
    return const PostingListState();
  }

  String? get _accessToken {
    final loginState = ref.watch(loginViewModelProvider);
    return loginState.token?.accessToken;
  }

  Future<void> initialize() async {
    Log.d("access Token : $_accessToken");
    if (_accessToken != null) {
      await _fetchInitial();
    } else {
      state = state.copyWith(
        postings: AsyncValue.error("토큰이 없습니다", StackTrace.current),
      );
    }
  }

  Future<void> _fetchInitial() async {
    state = state.copyWith(postings: const AsyncValue.loading());
    final postingsAsync = await AsyncValue.guard(() async {
      final token = _accessToken;
      Log.d("accessToken: $token");

      if (token == null) {
        throw Exception("로그인이 필요합니다");
      }

      final result = await _postingRepository.getPostings(token, null);
      switch (result) {
        case Success(data: final data):
          final Map<int, bool> initialScrapStatuses = {};
          for (var posting in data.data) {
            initialScrapStatuses[posting.id] = posting.scrapped;
          }
          ref
              .read(scrapStatusNotifierProvider.notifier)
              .setScrapStatuses(initialScrapStatuses);

          // 상태 업데이트 (cursor, hasMore)
          state = state.copyWith(
            cursor: data.page.cursor,
            hasMore: data.data.isNotEmpty,
          );
          return data.data;
        case Failure(error: final error):
          throw error;
        default:
          throw Exception("알 수 없는 오류가 발생했습니다.");
      }
    });

    state = state.copyWith(postings: postingsAsync);
  }

  Future<void> fetchNext() async {
    if (state.postings.isLoading || !state.hasMore) return;

    final token = _accessToken;
    if (token == null) return;

    final postingsAsync = await AsyncValue.guard(() async {
      final result = await _postingRepository.getPostings(token, state.cursor);
      switch (result) {
        case Success(data: final data):
          final newData = data.data;
          final currentData = state.postings.value ?? <Posting>[];

          final Map<int, bool> newScrapStatuses = {};
          for (var posting in newData) {
            newScrapStatuses[posting.id] = posting.scrapped;
          }
          ref
              .read(scrapStatusNotifierProvider.notifier)
              .setScrapStatuses(newScrapStatuses);

          // 상태 업데이트
          state = state.copyWith(
            cursor: data.page.cursor,
            hasMore: newData.isNotEmpty,
          );

          return [...currentData, ...newData];
        case Failure(error: final error):
          throw Exception(error.toString());
        default:
          throw Exception("알 수 없는 오류 발생");
      }
    });
    Log.d(
      'postings.length: ${state.postings.value!.length}, hasMore: ${state.hasMore}',
    );

    state = state.copyWith(postings: postingsAsync);
  }

  Future<void> refresh() async {
    // 커서 리셋 후 초기 데이터 가져오기
    state = state.copyWith(cursor: null, hasMore: false);
    await _fetchInitial();
  }
}
