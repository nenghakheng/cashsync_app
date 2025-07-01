import 'package:cashsyncapp/http/base_api.dart';

class AuthService extends BaseApi {
  static const String endpoint = "/auth";

  Future<dynamic> login(String email, String password) async {
    final response = await post(endpoint, {
      "email": email,
      "password": password,
    });

    return response;
  }
}
