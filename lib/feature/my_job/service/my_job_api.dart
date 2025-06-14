import 'package:alter/core/api_response.dart';
import 'package:alter/core/network_provider.dart';
import 'package:alter/feature/my_job/model/my_job_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'my_job_api.g.dart';

final myJobApiProvider = Provider(
  (ref) => MyJobApiClient(ref.watch(dioProvider)),
);

@RestApi()
abstract class MyJobApiClient {
  factory MyJobApiClient(Dio dio, {String baseUrl}) = _MyJobApiClient;

  @GET('/app/users/me/postings/applications')
  Future<HttpResponse<ApplyResponse>> getApplications(
    @Header('Authorization') String auth,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );

  @PATCH('/app/users/me/postings/applications/{applicationId}/status')
  Future<ApiResponse> updateApplyStatus(
    @Header('Authorization') String auth,
    @Path('applicationId') int applicationId,
    @Body() ApplyStatusUpdateRequest body,
  );
}
