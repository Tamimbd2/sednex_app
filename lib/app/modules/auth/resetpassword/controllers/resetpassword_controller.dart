import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../../services/api_service.dart';

class ResetpasswordController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  late String token;

  @override
  void onInit() {
    super.onInit();
    token = Get.arguments ?? '';
  }

  void resetPassword() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        final response = await _apiService.postData('api/auth/reset-password/', {
          'token': token,
          'newPassword': passwordController.text,
          'confirmPassword': confirmPasswordController.text,
        });

        if (response.statusCode == 200) {
          Get.snackbar(
            'Success',
            'Password reset successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
          );
          Get.offAllNamed(Routes.SIGNIN);
        } else {
          Get.snackbar(
            'Error',
            response.body['message'] ?? 'Failed to reset password',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
        }
      } catch (e) {
        debugPrint("Error resetting password: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }

}
