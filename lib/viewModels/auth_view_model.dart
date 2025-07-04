import 'package:cashsyncapp/http/api/auth_service.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:cashsyncapp/viewModels/base_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();

  UserModel? currentUser;
  String? errorMessage;
  bool isAuthenticated = false;

  AuthViewModel() {
    _initAuthState(); // Initialize auth state on object creation
  }

  Future<void> _initAuthState() async {
    setLoading(true);
    try {
      // Check if token exists in storage
      final token = await const FlutterSecureStorage().read(key: 'auth_token');

      if (token != null && token.isNotEmpty) {
        // Token exists, try to get current user
        currentUser = await _authService.getCurrentUser();
        isAuthenticated = currentUser != null;
        print(
          "Auth state restored: ${isAuthenticated ? 'Authenticated' : 'Not authenticated'}",
        );
      }
    } catch (e) {
      print("Error initializing auth state: $e");
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
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

  // Sign Up
  Future<bool> signUp(String email, String password) async {
    errorMessage = null;
    setLoading(true);

    try {
      final response = await _authService.signUp(email, password);

      if (response != null) {
        // Automatically log in after successful sign up
        final loginResponse = await _authService.login(email, password);
        if (loginResponse != null && loginResponse['data']['token'] != null) {
          currentUser = await _authService.getCurrentUser();
          isAuthenticated = true;
        } else {
          errorMessage = "Sign up succeeded but login failed";
          return false;
        }
        notifyListeners();
        return true;
      } else {
        errorMessage = "Sign up failed";
        return false;
      }
    } catch (error) {
      errorMessage = "Sign up failed: ${error.toString()}";
      print('Sign up error: $error');
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
