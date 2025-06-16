import 'package:alter/common/util/logger.dart';
import 'package:alter/core/result.dart';
import 'package:alter/feature/profile/model/profile_request_model.dart';
import 'package:alter/feature/profile/model/profile_response_model.dart';
import 'package:alter/feature/profile/service/profile_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref.read(profileApiProvider)),
);

class ProfileRepository {
  final ProfileApiClient _profileApi;

  ProfileRepository(this._profileApi);
  // 유저 프로필 조회
  Future<Result<UserProfile>> getProfile(String auth) async {
    try {
      final response = await _profileApi.getProfile("Bearer $auth");

      return Result.success(response.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 프로필 조회"));
    }
  }

  // 유저 자격 정보 조회
  Future<Result<List<Certificate>>> getcertificates(String auth) async {
    try {
      final response = await _profileApi.getcertificates("Bearer $auth");

      return Result.success(response.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 자격 조회"));
    }
  }

  // 자격 정보 등록
  Future<Result> addCertificate(String auth, CertificateRequest body) async {
    try {
      final response = await _profileApi.addCertificate("Bearer $auth", body);

      return Result.success(response);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 자격 추가"));
    }
  }

  // 자격 정보 상세
  Future<Result<Certificate>> getCertificateDetail(String auth, int id) async {
    try {
      final response = await _profileApi.getCertificateDetail(
        "Bearer $auth",
        id,
      );

      return Result.success(response.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 자격 상세 조회"));
    }
  }

  // 자격 정보 수정
  Future<Result> updateCertificate(
    String auth,
    int id,
    CertificateRequest body,
  ) async {
    try {
      final response = await _profileApi.updateCertificate(
        "Bearer $auth",
        id,
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
      return Result.failure(Exception("요청 실패 : 자격 수정"));
    }
  }

  // 자격 정보 삭제
  Future<Result> deleteCertificate(String auth, int id) async {
    try {
      final response = await _profileApi.deleteCertificate("Bearer $auth", id);

      return Result.success(response);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final response = e.response?.data;
      Log.e("[$status] response: $response");

      return Result.failure(e);
    } catch (e) {
      Log.e(e.toString());
      return Result.failure(Exception("요청 실패 : 자격 삭제"));
    }
  }
}
