import 'package:alter/feature/home/service/naver_geo_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('naver geo 작동 테스트', () {
    final dio = Dio();
    final geo = NaverGeoService(dio);
  });
}
