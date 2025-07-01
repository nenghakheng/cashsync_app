import 'package:cashsyncapp/viewModels/base_view_model.dart';

class AuthViewModel extends BaseViewModel {
  // This class can be extended to handle authentication logic
  // For example, you can add methods for login, logout, and registration

  AuthViewModel() {
    // Initialize any necessary data or services here
  }

  // Example method for login
  Future<void> login(String username, String password) async {
    setLoading(true);
    // Implement your login logic here
    // After successful login, you might want to notify listeners
    setLoading(false);
  }

  // Example method for logout
  Future<void> logout() async {
    setLoading(true);
    // Implement your logout logic here
    setLoading(false);
  }
}
