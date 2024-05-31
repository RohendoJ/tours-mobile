import 'package:dio/dio.dart';
import '../utils/utils.dart';

class SignInService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> signInAccount(
      String username, String password) async {
    try {
      final response = await _dio.post(
        Urls.baseUrl + Urls.signIn,
        data: {
          'username': username,
          'password': password,
        },
      );

      return response.data;
    } catch (error) {
      // ignore: avoid_print
      print('Terjadi kesalahan saat melakukan permintaan: $error');
      return null;
    }
  }
}
