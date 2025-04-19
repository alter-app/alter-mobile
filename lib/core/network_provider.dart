import 'package:alter/common/util/logger.dart';
import 'package:alter/core/env.dart';
import 'package:alter/core/secure_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: Env.testServerUrl,
    responseType: ResponseType.json,
    headers: {'Content-Type': 'application/json'},
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio(options);
  dio.interceptors.add(CustomInterceptor(storage: storage));
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // if (options.headers['Authorization'] == 'true') {
    //   options.headers.remove('Authorization');
    // }
    // final token = await storage.read(key: 'access_token');
    // options.headers.addAll({'Authorization': 'Bearer $token'});

    Log.d("REQUEST[${options.method}] => PATH: ${options.path}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Log.d("RESPONSE[${response.statusCode}] => BODY: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Log.e("ERROR[${err.response?.statusCode}] => MESSAGE: ${err.message}");
    super.onError(err, handler);
  }
}
