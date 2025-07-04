import 'package:cashsyncapp/http/api/auth_service.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:flutter/foundation.dart';

class CurrentUserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  CurrentUserProvider() {
    // Initialize by trying to get the current user
    refreshUser();
  }

  // Set the current user and notify listeners
  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
    print("CurrentUserProvider: User updated: ${user?.name ?? 'null'}");
  }

  // Refresh the current user from the API
  Future<void> refreshUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("CurrentUserProvider: Refreshing user data");
      final user = await _authService.getCurrentUser();

      // Update the current user
      _currentUser = user;
      print("CurrentUserProvider: User refreshed: ${user?.name ?? 'null'}");
    } catch (e) {
      print("CurrentUserProvider: Error refreshing user: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear the current user (for logout)
  void clearUser() {
    _currentUser = null;
    notifyListeners();
    print("CurrentUserProvider: User cleared");
  }
}
