import 'package:cashsyncapp/http/api/profile_service.dart';
import 'package:cashsyncapp/models/user_model.dart';
import 'package:cashsyncapp/viewModels/base_view_model.dart';

class ProfileViewModel extends BaseViewModel {
  final ProfileService _profileService = ProfileService();
  final bool isLoading = false;

  Future<void> uploadProfileImage(String? id, String filePath) async {
    setLoading(true);

    try {
      if (filePath.isEmpty) {
        throw Exception("File path must not be empty");
      }
      final response = await _profileService.uploadProfileImage(id, filePath);
      if (response != null) {
        // Handle successful upload, e.g., update user profile in secure storage
        print("Profile picture uploaded successfully: $response");
      }
    } catch (e) {
      // Handle error
      print('Error uploading profile picture: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateProfile({String? id, UserModel? user}) async {
    setLoading(true);
    try {
      if (id == null || user == null) {
        throw Exception("User ID and User data must not be null");
      }
      final response = await _profileService.updateProfile(id, user);
      if (response != null) {
        // Update the user profile in secure storage
        print("Profile updated successfully: $response");
      }
    } catch (e) {
      // Handle error
      print('Error updating profile: $e');
    } finally {
      setLoading(false);
    }
  }
}
