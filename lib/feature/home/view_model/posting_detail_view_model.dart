import 'package:alter/core/result.dart';
import 'package:alter/feature/auth/view_model/login_view_model.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/repository/posting_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'posting_detail_view_model.freezed.dart';

@freezed
abstract class PostingDetailState with _$PostingDetailState {
  const factory PostingDetailState({
    @Default(AsyncValue.loading()) AsyncValue<PostingDetail> posting,
  }) = _PostingDetailState;
}

final postingDetailViewModelProvider =
    NotifierProvider.family<PostingDetailViewModel, PostingDetailState, String>(
      () => PostingDetailViewModel(),
    );

class PostingDetailViewModel
    extends FamilyNotifier<PostingDetailState, String> {
  PostingRepository get _postingRepository =>
      ref.watch(postingRepositoryProvider);

  String get _postingId => arg;

  @override
  PostingDetailState build(String postingId) {
    return const PostingDetailState();
  }

  String? get _accessToken {
    final loginState = ref.watch(loginViewModelProvider);
    return loginState.token?.accessToken;
  }

  Future<void> fetchData() async {
    state = state.copyWith(posting: const AsyncValue.loading());

    final postingAsync = await AsyncValue.guard(() async {
      final token = _accessToken;
      final id = int.tryParse(_postingId);

      if (token == null) {
        throw Exception("로그인이 필요합니다.");
      }
      if (id == null) {
        throw Exception("잘못된 post id입니다.");
      }

      final result = await _postingRepository.getPostingDetail(token, id);
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
}
