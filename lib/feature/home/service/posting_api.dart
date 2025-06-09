import 'package:alter/core/api_response.dart';
import 'package:alter/core/network_provider.dart';
import 'package:alter/feature/home/model/posting_request_model.dart';
import 'package:alter/feature/home/model/posting_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'posting_api.g.dart';

final postingApiProvider = Provider(
  (ref) => PostingApiClient(ref.watch(dioProvider)),
);

@RestApi()
abstract class PostingApiClient {
  factory PostingApiClient(Dio dio, {String baseUrl}) = _PostingApiClient;

  // 공고 조회 커서 페이징
  /*
  초기 요청 때는 cursor 파라미터 없이 보냈다가 
  다음 페이지 요청할 때는 응답으로 온 cursor를 cursor 파라미터에 넣어서 요청하면 됨
  반복적으로 요청하다가 빈 data로 응답될 경우 스크롤 안 되게 막고 (이제 더이상 데이터가 없다는 의미)
   */

  // 추후 auth는 dio interceptor에서 처리 할 예정
  @GET("/app/postings")
  Future<HttpResponse<PostingResponse>> getPostings(
    @Header('Authorization') String auth, // 'true' or other 아니면 authToken 입력
    @Query('cursor') String? cursor,
    @Query('pageSize') int pageSize,
  );

  @POST("/app/postings")
  Future<ApiResponse> createPosting(
    @Header('Authorization') String auth,
    @Body() PostingRequest body,
  );

  @GET("/app/postings/{postingId}")
  Future<HttpResponse<ApiResponse<PostingDetail>>> getPostingDetail(
    @Header('Authorization') String auth,
    @Path('postingId') int postingId,
  );

  @GET("/app/postings/available-keywords")
  Future<ApiResponse<List<Keyword>>> getKeywords(
    @Header('Authorization') String auth,
  );

  @POST("/app/users/me/postings/favorites/{postingId}")
  Future<ApiResponse> addScrap(
    @Header('Authorization') String auth,
    @Path('postingId') int postingId,
  );

  @DELETE("/app/users/me/postings/favorites/{postingId}")
  Future<ApiResponse> deleteScrap(
    @Header('Authorization') String auth,
    @Path('postingId') int postingId,
  );
}
