import 'package:cashsyncapp/http/base_api.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:japx/japx.dart';

class AuthService extends BaseApi {
  static const String endpoint = "/auth";
  final storage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<dynamic> login(String email, String password) async {
    final response = await post("$endpoint", {
      "email": email,
      "password": password,
    });

    // Store the JWT token if it's in the response
    if (response != null && response['token'] != null) {
      await storage.write(key: 'auth_token', value: response['token']);
    }

    return response;
  }

  Future<dynamic> googleLogin() async {
    try {
      // Start the Google Sign In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Get Google authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Send the ID token to your backend
      final response = await post("$endpoint/google", {
        "idToken": googleAuth.idToken,
      });

      print("Google Auth response: $response");

      // Extract the token from the response
      if (response != null &&
          response['data'] != null &&
          response['data']['token'] != null) {
        final token = response['data']['token'];
        await storage.write(key: 'auth_token', value: token);
      } else {
        print("Token not found in response");
        return {'error': 'Token not found in response'};
      }

      return response;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return {'error': error.toString()};
    }
  }

  Future<UserModel?> getCurrentUser() async {
    // Get the stored JWT token
    final token = await storage.read(key: 'auth_token');

    if (token == null) {
      return null; // Not logged in
    }

    try {
      // Add the token to request headers
      final response = await get("$endpoint/me", withAuth: true);

      print("Response from getCurrentUser: $response");

      if (response != null) {
        return UserModel.fromJson(response);
      }
    } catch (e) {
      print('Get Current User Error: $e');
      // Token might be invalid, clear it
      await storage.delete(key: 'auth_token');
    }

    return null;
  }

  Future<bool> logout() async {
    try {
      // Sign out from Google if signed in
      await _googleSignIn.signOut();

      // Clear the stored JWT token
      await storage.delete(key: 'auth_token');
      return true;
    } catch (e) {
      print('Logout Error: $e');
      return false;
    }
  }
}
