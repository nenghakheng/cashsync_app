import 'package:cashsyncapp/http/api/user_service.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:cashsyncapp/viewModels/base_view_model.dart';

class UserViewModel extends BaseViewModel {
  final UserService _userService = UserService();
  List<UserModel?> users = [];
  UserModel? user;

  UserViewModel() {
    load(); // Call load function on object creation
  }

  void load() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setLoading(true);

    // Fetching users
    users = await _userService.fetchAllUsers();
    notifyListeners(); // Notify listeners that the data has changed

    setLoading(false);
  }

  Future<void> fetchUserById(int id) async {
    setLoading(true);

    // Fetching user by ID
    user = await _userService.fetchUserById(id);
    notifyListeners(); // Notify listeners that the data has changed

    setLoading(false);
  }
}
