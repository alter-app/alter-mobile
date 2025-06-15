import 'package:alter/core/api_response.dart';
import 'package:alter/core/network_provider.dart';
import 'package:alter/feature/profile/model/profile_request_model.dart';
import 'package:alter/feature/profile/model/profile_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api.g.dart';

final profileApiProvider = Provider(
  (ref) => ProfileApiClient(ref.watch(dioProvider)),
);

@RestApi()
abstract class ProfileApiClient {
  factory ProfileApiClient(Dio dio, {String baseUrl}) = _ProfileApiClient;

  // 유저 프로필 조회
  @GET('/app/users/me')
  Future<ApiResponse<UserProfile>> getProfile(
    @Header('Authorization') String auth,
  );

  // 유저 자격 정보 조회
  @GET('/app/users/me/certificates')
  Future<ApiResponse<List<Certificate>>> getcertificates(
    @Header('Authorization') String auth,
  );

  // 자격 정보 등록
  @POST('/app/users/me/certificates')
  Future<ApiResponse> addCertificate(
    @Header('Authorization') String auth,
    @Body() CertificateRequest body,
  );

  // 자격 정보 상세
  @GET('/app/users/me/certificates/{certificateId}')
  Future<ApiResponse<Certificate>> getCertificateDetail(
    @Header('Authorization') String auth,
    @Path('certificateId') int certificateId,
  );

  // 자격 정보 수정
  @PUT('/app/users/me/certificates/{certificateId}')
  Future<ApiResponse> updateCertificate(
    @Header('Authorization') String auth,
    @Path('certificateId') int certificateId,
    @Body() CertificateRequest body,
  );

  // 자격 정보 삭제
  @DELETE('/app/users/me/certificates/{certificateId}')
  Future<ApiResponse> deleteCertificate(
    @Header('Authorization') String auth,
    @Path('certificateId') int certificateId,
  );
}
