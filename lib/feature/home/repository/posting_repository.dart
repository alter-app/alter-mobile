import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/service/posting_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postingRepositoryProvider = Provider(
  (ref) => PostingRepository(ref.watch(postingApiProvider)),
);

class PostingRepository {
  final PostingApiClient postingApi;

  PostingRepository(this.postingApi);

  Future<Result<PostingResponse>> getPostings(
    String auth,
    String? cursor,
  ) async {
    try {
      final httpResponse = await postingApi.getPostings(
        "Bearer $auth",
        cursor,
        10,
      );
      final response = httpResponse.data;

      return Result.success(response);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 공고 조회"));
    }
  }

  Future<Result<bool>> createPosting() async {
    throw Exception();
  }
}
