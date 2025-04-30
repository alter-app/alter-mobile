import 'package:alter/core/api_response.dart';
import 'package:alter/core/network_provider.dart';
import 'package:alter/feature/auth/model/login_request_model.dart';
import 'package:alter/feature/auth/model/login_response_model.dart';
import 'package:alter/feature/auth/model/signup_request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

final authApiProvider = Provider(
  (ref) => AuthApiClient(ref.watch(dioProvider)),
);

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST("/public/users/login")
  Future<HttpResponse<ApiResponse<LoginResponse>>> login(
    @Body() LoginRequest body,
  );

  @POST("/public/users/exists/nickname")
  Future<HttpResponse> checkNickname(@Body() NicknameCheckRequest body);

  @POST("/public/users/signup")
  Future<HttpResponse<ApiResponse<LoginResponse>>> signup(
    @Body() SignupRequest body,
  );
}
