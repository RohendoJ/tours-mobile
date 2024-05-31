import 'package:dio/dio.dart';
import '../utils/utils.dart';

class ProvincesService {
  final Dio _dio = Dio();

  Future getProvinces() async {
    try {
      final response = await _dio.get(
        Urls.provinceUrl,
      );
      final jsonData = response.data;
      return jsonData;
    } catch (error) {
      print('Terjadi kesalahan saat melakukan permintaan: $error');
      return null;
    }
  }
}
