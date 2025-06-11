import 'package:alter/common/util/logger.dart';
import 'package:alter/core/api_response.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/home/model/apply_request_model.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:alter/feature/home/service/posting_api.dart';
import 'package:alter/feature/my_job/model/posting_request_model.dart';
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

  Future<Result<PostingDetail>> getPostingDetail(
    String auth,
    int postingId,
  ) async {
    try {
      final httpResponse = await postingApi.getPostingDetail(
        "Bearer $auth",
        postingId,
      );
      final response = httpResponse.data.data;

      return Result.success(response);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 공고 상세"));
    }
  }

  Future<Result<ApiResponse>> createPosting(
    String auth,
    PostingRequest body,
  ) async {
    try {
      final response = await postingApi.createPosting("Bearer $auth", body);

      return Result.success(response);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 공고 등록"));
    }
  }

  Future<Result<List<Keyword>>> getKeywords(String auth) async {
    try {
      final response = await postingApi.getKeywords("Bearer $auth");

      return Result.success(response.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 키워드 목록"));
    }
  }

  Future<Result> addScrap(String auth, int postingId) async {
    try {
      final response = await postingApi.addScrap("Bearer $auth", postingId);

      return Result.success(response);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 스크랩 추가"));
    }
  }

  Future<Result> deleteScrap(String auth, int postingId) async {
    try {
      final response = await postingApi.deleteScrap("Bearer $auth", postingId);

      return Result.success(response);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 스크랩 삭제"));
    }
  }

  Future<Result> applyJob(String auth, int postingId, ApplyRequest body) async {
    try {
      final response = await postingApi.applyJob(
        "Bearer $auth",
        postingId,
        body,
      );

      return Result.success(response);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status]: ${e.type} response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 공고 지원"));
    }
  }
}
