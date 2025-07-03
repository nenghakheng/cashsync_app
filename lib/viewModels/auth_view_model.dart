import 'package:cashsyncapp/http/api/auth_service.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:cashsyncapp/viewModels/base_view_model.dart';

class AuthViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();

  UserModel? currentUser;
  String? errorMessage;
  bool isAuthenticated = false;

  AuthViewModel() {
    checkAuthStatus();
  }

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    print("Checking authentication status...");
    setLoading(true);
    try {
      // Try to get current user from secure storage
      currentUser = await _authService.getCurrentUser();
      isAuthenticated = currentUser != null;
    } catch (e) {
      errorMessage = "Error checking authentication status";
      print(errorMessage);
    }
    setLoading(false);
  }

  // Standard login
  Future<bool> login(String email, String password) async {
    errorMessage = null;
    setLoading(true);

    try {
      final response = await _authService.login(email, password);

      if (response != null && response['data']['token'] != null) {
        currentUser = await _authService.getCurrentUser();
        isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        errorMessage = "Invalid credentials";
        return false;
      }
    } catch (error) {
      errorMessage = "Login failed: ${error.toString()}";
      print('Login error: $error');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Google login
  Future<bool> googleLogin() async {
    errorMessage = null;
    setLoading(true);

    try {
      final response = await _authService.googleLogin();

      if (response != null && response['data']['token'] != null) {
        currentUser = await _authService.getCurrentUser();
        isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        errorMessage = "Google login failed";
        return false;
      }
    } catch (error) {
      errorMessage = "Google login failed: ${error.toString()}";
      print('Google login error: $error');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    setLoading(true);
    try {
      await _authService.logout();
      currentUser = null;
      isAuthenticated = false;
    } catch (error) {
      errorMessage = "Logout failed: ${error.toString()}";
      print('Logout error: $error');
    }
    setLoading(false);
    notifyListeners();
  }
}
