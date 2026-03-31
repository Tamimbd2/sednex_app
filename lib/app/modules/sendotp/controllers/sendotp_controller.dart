import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_service.dart';

class SendotpController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  void sendCode() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        final response = await _apiService.postData('api/auth/forgot-password', {
          'email': emailController.text.trim(),
        });

        if (response.statusCode == 200) {
          Get.snackbar(
            'Success',
            response.body['message'] ?? 'OTP sent to your email',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
          );
          Get.toNamed(Routes.VERIFYOTP, arguments: emailController.text.trim());
        } else {
          Get.snackbar(
            'Error',
            response.body['message'] ?? 'Failed to send OTP',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
        }
      } catch (e) {
        debugPrint("Error sending OTP: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}

