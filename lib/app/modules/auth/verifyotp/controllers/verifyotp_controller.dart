import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/api_service.dart';

class VerifyotpController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final isLoading = false.obs;
  
  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments ?? '';
  }

  void verifyCode() async {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      try {
        isLoading.value = true;
        final response = await _apiService.postData('api/auth/otp-verification/', {
          'email': email,
          'otp': otp,
        });

        if (response.statusCode == 200) {
          final token = response.body['token'];
          Get.snackbar(
            'Success',
            'OTP Verified',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
          );
          Get.toNamed(Routes.RESETPASSWORD, arguments: token);
        } else {
          Get.snackbar(
            'Error',
            response.body['message'] ?? 'OTP verification failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
          );
        }
      } catch (e) {
        debugPrint("Error verifying OTP: $e");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        'Error',
        'Please enter a 6-digit code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  void resendCode() async {
    if (email.isEmpty) return;
    
    try {
      final response = await _apiService.postData('api/auth/forgot-password/', {
        'email': email,
      });

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'OTP Resent to $email',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
      } else {
        Get.snackbar(
          'Error',
          response.body['message'] ?? 'Failed to resend code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("Error resending OTP: $e");
    }
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
