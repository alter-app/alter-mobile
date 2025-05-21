import 'package:alter/core/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverGeoService {
  final Dio _dio;
  final url = 'https://maps.apigw.ntruss.com';

  NaverGeoService(this._dio);

  Future<NLatLng> addressToCoord(String address) async {
    final response = await _dio.get(
      "$url/map-geocode/v2/geocode",
      queryParameters: {'query': address},
      options: Options(
        headers: {
          'Accept': 'application/json',
          'x-ncp-apigw-api-key-id': Env.naverClientId,
          'x-ncp-apigw-api-key': Env.naverClientSecret,
        },
      ),
    );

    final result = response.data['addresses'].first;
    return NLatLng(double.parse(result['y']), double.parse(result['x']));
  }

  Future<String> coordToAddress(double lat, double lon) async {
    final response = await _dio.get(
      '$url/map-reversegeocode/v2/gc',
      queryParameters: {
        'coords': '$lon,$lat',
        'output': 'json',
        'orders': 'roadaddr,addr',
      },
      options: Options(
        headers: {
          'x-ncp-apigw-api-key-id': Env.naverClientId,
          'x-ncp-apigw-api-key': Env.naverClientSecret,
        },
      ),
    );

    final result = response.data['results'].first;
    return "${result['region']['area1']['name']} ${result['land']['name']}";
  }
}
