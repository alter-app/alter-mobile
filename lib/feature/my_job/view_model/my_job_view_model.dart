import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/my_job/model/my_job_response_model.dart';
import 'package:alter/feature/my_job/repository/my_job_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_job_view_model.freezed.dart';

@freezed
abstract class MyJobListState with _$MyJobListState {
  const factory MyJobListState({
    @Default(AsyncValue.loading()) AsyncValue<List<Application>> applications,
    @Default(1) int page,
    @Default(1) int totalPage,
    @Default(false) bool hasMore,
  }) = _MyJobListState;
}

final myJobListViewModelProvider =
    NotifierProvider<MyJobListViewModel, MyJobListState>(
      () => MyJobListViewModel(),
    );

class MyJobListViewModel extends Notifier<MyJobListState> {
  MyJobRepository get _myJobRepository => ref.watch(myJobRepositoryProvider);

  @override
  MyJobListState build() {
    return const MyJobListState();
  }

  String? get _accessToken {
    final loginState = ref.watch(loginViewModelProvider);
    return loginState.token?.accessToken;
  }

  Future<void> initialize() async {
    if (_accessToken != null) {
      _fetchInitial();
    } else {
      state = state.copyWith(
        applications: AsyncValue.error("토큰이 없습니다.", StackTrace.current),
      );
    }
  }

  Future<void> _fetchInitial() async {
    Log.d("state: ${state.toString()}");
    if (state.page > state.totalPage) return;
    state = state.copyWith(applications: const AsyncValue.loading());

    final applicationsAsync = await AsyncValue.guard(() async {
      final token = _accessToken;
      Log.d("accessToken: $token");

      if (token == null) {
        throw Exception("로그인이 필요합니다.");
      }

      final result = await _myJobRepository.getApplications(token, state.page);
      switch (result) {
        case Success(data: final data):
          final currentPage = state.page;
          final newTotalPage = data.page.totalPage;

          state = state.copyWith(
            hasMore: (currentPage + 1) <= newTotalPage,
            page: currentPage + 1,
            totalPage: data.page.totalPage,
          );
          return data.data;
        case Failure(error: final error):
          throw error;
        default:
          throw Exception("알 수 없는 오류가 발생했습니다.");
      }
    });

    state = state.copyWith(applications: applicationsAsync);
  }

  Future<void> fetchNext() async {
    if (state.applications.isLoading || !state.hasMore) return;

    final applicationsAsync = await AsyncValue.guard(() async {
      final token = _accessToken;
      Log.d("accessToken: $token");

      if (token == null) {
        throw Exception("로그인이 필요합니다.");
      }

      final result = await _myJobRepository.getApplications(token, state.page);
      switch (result) {
        case Success(data: final data):
          final currentPage = state.page;
          final newData = data.data;
          final currentData = state.applications.value ?? [];

          state = state.copyWith(
            hasMore: (currentPage + 1) <= state.totalPage,
            page: currentPage + 1,
          );
          return [...currentData, ...newData];
        case Failure(error: final error):
          throw error;
        default:
          throw Exception("알 수 없는 오류가 발생했습니다.");
      }
    });

    state = state.copyWith(applications: applicationsAsync);
  }

  Future<void> refresh() async {
    state = state.copyWith(hasMore: false, page: 1);
    await _fetchInitial();
  }
}
