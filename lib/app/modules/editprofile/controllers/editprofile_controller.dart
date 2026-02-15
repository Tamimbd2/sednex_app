import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditprofileController extends GetxController {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    nameController.text = "Shamim Islam";
    phoneController.text = "+1 234 567 8900";
    locationController.text = "Lebanan, Lebanan"; // Matches screenshot typo "Lebanan"
    bioController.text = "Tell us about yourself...";
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
