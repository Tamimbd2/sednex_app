import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SigninController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final connect = GetConnect();
      final response = await connect.post(
        'https://sednex-zvk1.onrender.com/api/auth/login',
        {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
      );

      var body = response.body;
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (_) {}
      }

      if (response.statusCode == 200 && body is Map) {
        // Store token
        final token = body['token'] ?? '';
        final user = body['user'] ?? {};

        final box = GetStorage();
        await box.write('token', token);
        await box.write('user', jsonEncode(user));
        await box.write('isLoggedIn', true);

        debugPrint('Login successful! Token: $token');

        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF22C55E),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        // Navigate to dashboard
        Get.offAllNamed('/dashboard');
      } else {
        // Error from API
        final message = body is Map
            ? (body['message'] ?? 'Login failed')
            : 'Login failed';
        Get.snackbar(
          'Error',
          message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFDC143C),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDC143C),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
