import 'package:alter/core/result.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/repository/posting_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'posting_view_model.freezed.dart';

@freezed
abstract class PostingListState with _$PostingListState {
  const factory PostingListState({
    @Default([]) List<Posting> postings,
    String? cursor,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    @Default(null) String? error,
  }) = _PostingListState;
}

final postingListViewModelProvider =
    NotifierProvider<PostingListViewModel, PostingListState>(
      () => PostingListViewModel(),
    );

class PostingListViewModel extends Notifier<PostingListState> {
  late final PostingRepository _postingRepository;
  final String _authToken = "auth"; // 추후 수정

  @override
  PostingListState build() {
    _postingRepository = ref.watch(postingRepositoryProvider);
    // 여기에 auth 토큰 provider가 있어야 함
    _fetchInitial();
    return const PostingListState();
  }

  Future<void> _fetchInitial() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _postingRepository.getPostings(
      _authToken,
      state.cursor,
    );
    switch (result) {
      case Success(data: final data):
        state = state.copyWith(
          postings: data.data,
          cursor: data.page.cursor,
          hasMore: data.data.isNotEmpty,
          isLoading: false,
        );
      case Failure(error: final error):
        state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<void> fetchNext() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _postingRepository.getPostings(
      _authToken,
      state.cursor,
    );
    switch (result) {
      case Success(data: final data):
        final newData = data.data;
        state = state.copyWith(
          postings: [...state.postings, ...newData],
          cursor: data.page.cursor,
          hasMore: newData.isNotEmpty,
          isLoading: false,
        );
      case Failure(error: final error):
        state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<void> refresh() async {
    await _fetchInitial();
  }
}
