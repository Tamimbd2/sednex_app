import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SendotpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  void sendCode() {
    if (formKey.currentState!.validate()) {
      // Logic to send OTP
      Get.snackbar(
        'Success',
        'OTP sent to ${emailController.text}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      Get.toNamed(Routes.VERIFYOTP);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
