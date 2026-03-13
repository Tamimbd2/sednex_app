import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

class VerifyotpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  void verifyCode() {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      Get.snackbar(
        'Success',
        'OTP Verified: $otp',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
      Get.toNamed(Routes.RESETPASSWORD);
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

  void resendCode() {
    Get.snackbar(
      'Success',
      'OTP Resent',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      colorText: Colors.green,
    );
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
