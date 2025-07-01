import 'package:cashsyncapp/http/base_api.dart';
import 'package:cashsyncapp/models/user_model.dart';

class UserService extends BaseApi {
  static const String endpoint = "/users";

  Future<List<UserModel>> fetchAllUsers() async {
    final response = await get(endpoint);

    return (response as List).map((user) => UserModel.fromJson(user)).toList();
  }

  Future<UserModel> fetchUserById(int id) async {
    final response = await get("$endpoint/$id");

    return UserModel.fromJson(response);
  }
}
