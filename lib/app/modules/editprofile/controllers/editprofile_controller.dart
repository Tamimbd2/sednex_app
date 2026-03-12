import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class EditprofileController extends GetxController {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void _loadFromStorage() {
    final rawUser = _box.read('user');
    if (rawUser != null) {
      try {
        final user = rawUser is String ? jsonDecode(rawUser) : rawUser;
        nameController.text = user['name']?.toString() ?? '';
        phoneController.text = user['phone']?.toString() ?? '';
        locationController.text = user['location']?.toString() ?? '';
        bioController.text = user['bio']?.toString() ?? '';
      } catch (_) {}
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void saveChanges() {
    // Here you would typically call an API to update the profile
    Get.back();
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
