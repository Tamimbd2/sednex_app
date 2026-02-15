import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmNewPasswordVisible = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }

  void toggleCurrentPasswordVisibility() => isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  void toggleNewPasswordVisibility() => isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmNewPasswordVisibility() => isConfirmNewPasswordVisible.value = !isConfirmNewPasswordVisible.value;

  void updatePassword() {
    // Validate inputs
    if (newPasswordController.text != confirmNewPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    // Proceed with update
    Get.back();
    Get.snackbar('Success', 'Password updated successfully', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
  }
}
