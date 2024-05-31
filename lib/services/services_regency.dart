import 'package:dio/dio.dart';
import '../utils/utils.dart';

class RegencyService {
  final Dio _dio = Dio();

  Future getRegencies(dynamic id) async {
    try {
      final response = await _dio.get(
        '${Urls.regencyUrl}/$id.json',
      );
      final jsonData = response.data;
      return jsonData;
    } catch (error) {
      print('Terjadi kesalahan saat melakukan permintaan: $error');
      return null;
    }
  }
}
