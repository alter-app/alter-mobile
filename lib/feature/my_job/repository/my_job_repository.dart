import 'package:alter/common/util/logger.dart';
import 'package:alter/core/api_response.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/my_job/model/my_job_response_model.dart';
import 'package:alter/feature/my_job/service/my_job_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myJobRepositoryProvider = Provider(
  (ref) => MyJobRepository(ref.watch(myJobApiProvider)),
);

class MyJobRepository {
  final MyJobApiClient myJobApi;

  MyJobRepository(this.myJobApi);

  // 지원 알바 리스트
  Future<Result<ApplyResponse>> getApplications(String auth, int page) async {
    try {
      final httpResponse = await myJobApi.getApplications(
        "Bearer $auth",
        page,
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
      return Result.failure(Exception("요청 실패 : 지원 리스트 조회"));
    }
  }

  Future<Result<ApiResponse>> updateApplyStatus(
    String auth,
    int applicationId,
    ApplyStatusUpdateRequest body,
  ) async {
    try {
      final response = await myJobApi.updateApplyStatus(
        "Bearer $auth",
        applicationId,
        body,
      );

      return Result.success(response);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 지원 상태 업데이트"));
    }
  }
}
