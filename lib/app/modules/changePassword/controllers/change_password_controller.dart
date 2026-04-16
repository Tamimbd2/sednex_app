import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';

class ChangePasswordController extends GetxController {
  final apiService = Get.find<ApiService>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmNewPasswordVisible = false.obs;
  final isLoading = false.obs;

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

  Future<void> updatePassword() async {
    final oldPass = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmNewPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar('Error', 'All fields are required', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar('Error', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final response = await apiService.postData('api/auth/change-password', {
        'oldPassword': oldPass,
        'newPassword': newPass,
        'confirmPassword': confirmPass,
      });

      if (response.statusCode == 200) {
        Get.snackbar('Success', response.body['message'] ?? 'Password updated successfully', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        
        // Clear fields
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        
        Future.delayed(const Duration(seconds: 2), () => Get.back());
      } else {
        final errorMsg = response.body is Map ? (response.body['message'] ?? response.statusText) : response.statusText;
        Get.snackbar('Error', errorMsg ?? 'Failed to update password', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
