import 'package:cashsyncapp/http/api/cloudinary_service.dart';
import 'package:cashsyncapp/http/base_api.dart';
import 'package:cashsyncapp/models/user_model.dart';

class ProfileService extends BaseApi {
  static String endpoint = "/profile";
  final CloudinaryService _cloudinaryService = CloudinaryService();

  Future<UserModel?> updateProfile(String id, UserModel? profileData) async {
    endpoint = "$endpoint/$id";
    final response = await put(endpoint, profileData, withAuth: true);
    return response;
  }

  Future<UserModel?> getProfile() async {
    final response = await get(endpoint, withAuth: true);
    return response;
  }

  Future<UserModel?> uploadProfileImage(String? id, String imagePath) async {
    try {
      final String? imageUrl = await _cloudinaryService.simpleUpload(imagePath);

      if (imageUrl == null) {
        return null;
      }

      // Step 2: Update the user profile with the new image URL
      final String updateImageEndpoint =
          "$endpoint/$id/image?imageUrl=$imageUrl";

      print("Endpoint: $updateImageEndpoint");

      final response = await put(updateImageEndpoint, null, withAuth: true);

      if (response != null) {
        print("Profile image updated successfully.");
        return UserModel.fromJson(response);
      } else {
        print("Failed to update profile image.");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Deletes the current profile image and replaces with a new one
  Future<UserModel?> replaceProfileImage(
    String id,
    String imagePath,
    String? oldImageUrl,
  ) async {
    try {
      // Step 1: Delete the old image if it exists
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        final String publicId = CloudinaryService.getPublicIdFromUrl(
          oldImageUrl,
        );
        if (publicId.isNotEmpty) {
          await _cloudinaryService.deleteImage(publicId);
        }
      }

      // Step 2: Upload the new image
      return uploadProfileImage(id, imagePath);
    } catch (e) {
      return null;
    }
  }
}
