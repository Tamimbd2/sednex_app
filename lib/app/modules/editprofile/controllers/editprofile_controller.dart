import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/url.dart';
import '../../profile/controllers/profile_controller.dart';

class EditprofileController extends GetxController {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  final _box = GetStorage();
  final _picker = ImagePicker();

  var isLoading = false.obs;
  var selectedImageBytes = Rx<Uint8List?>(null);
  var selectedImageName = ''.obs;
  var currentAvatar = ''.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void _loadFromStorage() {
    final rawUser = _box.read('user');
    if (rawUser != null) {
      try {
        final user = rawUser is String ? jsonDecode(rawUser) : rawUser;
        userId.value = user['_id']?.toString() ?? user['id']?.toString() ?? '';
        nameController.text = user['name']?.toString() ?? '';
        phoneController.text = user['phone']?.toString() ?? '';
        // Backend stores as 'country' but request field is 'location'
        locationController.text = user['country']?.toString() ?? '';
        bioController.text = user['bio']?.toString() ?? '';
        currentAvatar.value = user['profileImage']?.toString() ?? '';
      } catch (_) {}
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      selectedImageBytes.value = await pickedFile.readAsBytes();
      selectedImageName.value = pickedFile.name;
    }
  }

  Future<void> saveChanges() async {
    debugPrint('--- saveChanges() called ---');
    debugPrint('userId: ${userId.value}');

    if (userId.value.isEmpty) {
      Get.snackbar('Error', 'User information not found. Please log in again.');
      return;
    }

    try {
      isLoading.value = true;

      final token = _box.read('token') ?? '';
      final uri = Uri.parse('${AppUrl.baseUrl}api/users/${userId.value}');

      final request = http.MultipartRequest('PATCH', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = nameController.text.trim()
        ..fields['bio'] = bioController.text.trim()
        ..fields['phone'] = phoneController.text.trim()
        ..fields['country'] = locationController.text.trim();

      // Attach image if selected — field name is 'profileImage' (confirmed from Postman)
      if (selectedImageBytes.value != null) {
        final filename = selectedImageName.value.isNotEmpty
            ? selectedImageName.value
            : 'profile.jpg';
        request.files.add(http.MultipartFile.fromBytes(
          'profileImage',
          selectedImageBytes.value!,
          filename: filename,
        ));
      }

      debugPrint('Sending PATCH to $uri');
      final streamed = await request.send();
      final httpResponse = await http.Response.fromStream(streamed);

      debugPrint('Response status: ${httpResponse.statusCode}');
      debugPrint('Response body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        final parsed = jsonDecode(httpResponse.body);
        final updatedUser = parsed['user'] ?? parsed;
        _box.write('user', updatedUser);
        currentAvatar.value =
            updatedUser['profileImage']?.toString() ?? currentAvatar.value;

        // Instantly refresh ProfileController so the UI updates without restart
        _refreshProfile();

        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Map<String, dynamic>? parsed;
        try {
          parsed = jsonDecode(httpResponse.body);
        } catch (_) {}
        final msg = parsed?['message'] ?? 'Failed to update profile';
        Get.snackbar(
          'Error',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, st) {
      debugPrint('saveChanges error: $e\n$st');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  void _refreshProfile() {
    try {
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().loadUserFromStorage();
      }
    } catch (_) {}
  }
}
