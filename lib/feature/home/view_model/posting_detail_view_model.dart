import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/home/model/posting_request_model.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/repository/posting_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'posting_detail_view_model.freezed.dart';

@freezed
abstract class PostingDetailState with _$PostingDetailState {
  const factory PostingDetailState({
    @Default(AsyncValue.loading()) AsyncValue<PostingDetail> posting,
    @Default(false) bool isScrapped,
    int? selectedScheduleId,
    @Default("") String selfIntroduction,
  }) = _PostingDetailState;
}

final postingDetailViewModelProvider =
    NotifierProvider.family<PostingDetailViewModel, PostingDetailState, int>(
      () => PostingDetailViewModel(),
    );

class PostingDetailViewModel extends FamilyNotifier<PostingDetailState, int> {
  PostingRepository get _postingRepository =>
      ref.watch(postingRepositoryProvider);

  int get _postingId => arg;

  @override
  PostingDetailState build(int postingId) {
    return const PostingDetailState();
  }

  String? get _accessToken {
    final loginState = ref.watch(loginViewModelProvider);
    return loginState.token?.accessToken;
  }

  void updateSelectedSchdule(int? scheduleId) {
    if (scheduleId == null) {
      return;
    }
    state = state.copyWith(selectedScheduleId: scheduleId);
  }

  Future<void> fetchData() async {
    state = state.copyWith(posting: const AsyncValue.loading());

    final postingAsync = await AsyncValue.guard(() async {
      final token = _accessToken;

      if (token == null) {
        throw Exception("로그인이 필요합니다.");
      }

      final result = await _postingRepository.getPostingDetail(
        token,
        _postingId,
      );
      switch (result) {
        case Success(data: final data):
          return data;
        case Failure(error: final error):
          throw error;
        default:
          throw Exception("알 수 없는 오류가 발생했습니다.");
      }
    });

    state = state.copyWith(posting: postingAsync);
  }

  Future<void> toggleScrap() async {
    final token = _accessToken;
    final postingId = state.posting.when(
      data: (data) {
        return data.id;
      },
      error: (error, stackTrace) {
        return null;
      },
      loading: () {
        return null;
      },
    );

    if (token == null) {
      throw Exception("로그인이 필요합니다.");
    }
    if (postingId == null) {
      throw Exception("로딩 실패");
    }

    Result result;
    final before = state.isScrapped;
    if (state.isScrapped) {
      result = await _postingRepository.deleteScrap(token, postingId);
    } else {
      result = await _postingRepository.addScrap(token, postingId);
    }
    switch (result) {
      case Success():
        state = state.copyWith(isScrapped: !before);
      default:
        break;
    }
  }

  Future<bool> applyJob(int scheduleId, String description) async {
    final token = _accessToken;
    final postingId = state.posting.when(
      data: (data) {
        return data.id;
      },
      error: (error, stackTrace) {
        return null;
      },
      loading: () {
        return null;
      },
    );

    if (token == null) {
      throw Exception("로그인이 필요합니다.");
    }
    if (postingId == null) {
      throw Exception("로딩 실패");
    }

    final result = await _postingRepository.applyJob(
      token,
      postingId,
      ApplyRequest(postingScheduleId: scheduleId, description: description),
    );

    switch (result) {
      case Success():
        return true;
      default:
        return false;
    }
  }
}
