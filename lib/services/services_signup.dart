import 'package:dio/dio.dart';
import '../utils/utils.dart';

class SignUpService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> signUpAccount(
      String nameUser, String fullnameUser, String passwordUser) async {
    try {
      final response = await _dio.post(
        Urls.baseUrl + Urls.signUp,
        data: {
          'username': nameUser,
          'fullname': fullnameUser,
          'password': passwordUser,
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
