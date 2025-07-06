import 'dart:convert';
import 'dart:io';
import 'package:cashsyncapp/http/base_api.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService extends BaseApi {
  static final String apiKey = dotenv.env['CLOUDINARY_CLOUD_API_KEY']!;
  static final String apiSecret = dotenv.env['CLOUDINARY_CLOUD_API_SECRET']!;
  static final String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  static final String uploadPreset = dotenv.env["CLOUDINARY_CLOUD_PRESET"]!;
  static const String apiBaseUrl = "https://api.cloudinary.com/v1_1";

  String _generateSignature(Map<String, dynamic> params) {
    // Build the string to sign (exclude api_key, file)
    String stringToSign = '';

    // Create a sorted map of parameters
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    sortedParams.forEach((key, value) {
      if (value != null) {
        stringToSign += '$key=$value&';
      }
    });

    // Remove trailing '&' if present
    if (stringToSign.endsWith('&')) {
      stringToSign = stringToSign.substring(0, stringToSign.length - 1);
    }

    // Add API secret
    stringToSign += apiSecret;

    // Generate SHA-1 hash
    final bytes = utf8.encode(stringToSign);
    final digest = sha1.convert(bytes);

    return digest.toString();
  }

  /// Uploads a media file (image or video) to Cloudinary.
  /// Returns the secure URL if successful, null otherwise.
  Future<String?> uploadMedia(String filePath, {bool isVideo = false}) async {
    try {
      // Create the file object
      final File mediaFile = File(filePath);
      if (!await mediaFile.exists()) {
        print("File does not exist: $filePath");
        return null;
      }

      // Determine resource type (image or video)
      final String resourceType = isVideo ? 'video' : 'image';

      // Create FormData with file and upload parameters
      final filename = filePath.split("/").last;

      // Timestamp for the request
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Parameters for signature (exclude file and api_key)
      final Map<String, dynamic> signParams = {
        'timestamp': timestamp,
        'upload_preset': uploadPreset,
        'resource_type': resourceType,
      };

      // Generate the signature
      final signature = _generateSignature(signParams);

      // Create multipart form data
      final FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          mediaFile.path,
          filename: filename,
        ),
        'api_key': apiKey,
        'timestamp': timestamp,
        'signature': signature,
        'resource_type': resourceType,
        'upload_preset': uploadPreset,
      });

      // Upload URL
      final String uploadUrl = "$apiBaseUrl/$cloudName/$resourceType/upload";

      print(
        "Uploading ${isVideo ? 'video' : 'image'} to Cloudinary: $filename",
      );

      // Use Dio directly for this special case
      final response = await Dio().post(
        uploadUrl,
        data: formData,
        options: Options(headers: {'X-Requested-With': 'XMLHttpRequest'}),
      );

      if (response.statusCode == 200) {
        final secureUrl = response.data['secure_url'] as String?;
        print("Media uploaded successfully: $secureUrl");
        return secureUrl;
      } else {
        print("Upload failed with status ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading media: $e");
      return null;
    }
  }

  /// Convenience method for uploading an image
  Future<String?> uploadImage(String imagePath) async {
    return uploadMedia(imagePath, isVideo: false);
  }

  /// Convenience method for uploading a video
  Future<String?> uploadVideo(String videoPath) async {
    return uploadMedia(videoPath, isVideo: true);
  }

  /// Deletes a media from Cloudinary using its public ID.
  /// Returns true if successful, false otherwise.
  Future<bool> deleteMedia(String publicId, {bool isVideo = false}) async {
    try {
      final String resourceType = isVideo ? 'video' : 'image';

      // Create the delete request parameters
      final Map<String, dynamic> deleteParams = {
        'public_id': publicId,
        'resource_type': resourceType,
      };

      // Upload URL
      final String deleteUrl = "$apiBaseUrl/$cloudName/$resourceType/destroy";

      // Use Dio directly
      final response = await Dio().post(
        deleteUrl,
        data: deleteParams,
        options: Options(
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['result'] == 'ok') {
        print("Media deleted successfully: $publicId");
        return true;
      } else {
        print("Delete failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Error deleting media: $e");
      return false;
    }
  }

  /// Convenience method for deleting an image
  Future<bool> deleteImage(String publicId) async {
    return deleteMedia(publicId, isVideo: false);
  }

  /// Convenience method for deleting a video
  Future<bool> deleteVideo(String publicId) async {
    return deleteMedia(publicId, isVideo: true);
  }

  /// Gets the public ID from a Cloudinary URL
  static String getPublicIdFromUrl(String url) {
    // Example URL: https://res.cloudinary.com/your-cloud/image/upload/v1234567890/folder/public_id.jpg
    final Uri uri = Uri.parse(url);
    final List<String> pathSegments = uri.pathSegments;

    // Find the upload segment index
    final int uploadIndex = pathSegments.indexOf('upload');
    if (uploadIndex != -1 && uploadIndex + 2 < pathSegments.length) {
      // Skip version segment if present (starts with 'v')
      int startIndex = uploadIndex + 1;
      if (pathSegments[startIndex].startsWith('v') &&
          RegExp(r'^v\d+$').hasMatch(pathSegments[startIndex])) {
        startIndex++;
      }

      // Join the remaining segments to form the public ID (without file extension)
      final String fullPath = pathSegments.sublist(startIndex).join('/');
      // Remove file extension if present
      final int dotIndex = fullPath.lastIndexOf('.');
      return dotIndex != -1 ? fullPath.substring(0, dotIndex) : fullPath;
    }

    return '';
  }

  Future<String?> simpleUpload(String filePath) async {
    try {
      final file = File(filePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Calculate signature - critical for proper authentication
      final signString = "timestamp=$timestamp$apiSecret";
      final signature = sha1.convert(utf8.encode(signString)).toString();

      // Create form data
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'api_key': apiKey,
        'timestamp': timestamp,
        'signature': signature,
      });

      // Make the request
      final response = await Dio().post(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
        data: formData,
      );

      print("Simple upload response: ${response.data}");
      return response.data['secure_url'];
    } catch (e) {
      print("Simple upload error: $e");
      if (e is DioException) {
        print("Simple upload error response: ${e.response?.data}");
      }
      return null;
    }
  }
}
