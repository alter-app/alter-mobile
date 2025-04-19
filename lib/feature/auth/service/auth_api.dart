import 'package:alter/feature/auth/model/login_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST("/public/users/login")
  Future<LoginResponseModel> kakaoLogin(@Body() LoginRequestModel body);
}
