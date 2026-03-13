import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final countries = [
    'Lebanon',
    'Bangladesh',
    'India',
    'Pakistan',
    'United Arab Emirates',
    'United States',
  ];
  
  final selectedCountry = 'Lebanon'.obs;
  final isPasswordVisible = false.obs;

  void signup() {
    if (formKey.currentState!.validate()) {
      // Proceed with signup logic
      Get.snackbar(
        'Success',
        'Account created for ${nameController.text}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
