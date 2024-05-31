// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import '../utils/utils.dart';

class ProfileService {
  final Dio _dio = Dio();

  Future getProfile(String accessToken) async {
    try {
      final response = await _dio.get(
        Urls.baseUrl + Urls.getProfile,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final jsonData = response.data;
      return jsonData;
    } catch (error) {
      print('Terjadi kesalahan saat melakukan permintaan: $error');
      return null;
    }
  }
}
