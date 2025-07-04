import 'package:cashsyncapp/http/api/auth_service.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:cashsyncapp/viewModels/base_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();

  UserModel? currentUser;

  ProfileViewModel() {
    initialLoad();
  }

  Future<void> initialLoad() async {
    setLoading(true);
    try {
      // Check if token exists in storage
      final token = await const FlutterSecureStorage().read(key: 'auth_token');

      if (token != null && token.isNotEmpty) {
        // Token exists, try to get current user
        currentUser = await _authService.getCurrentUser();
      }
    } catch (e) {
      print("Error initializing auth state: $e");
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
