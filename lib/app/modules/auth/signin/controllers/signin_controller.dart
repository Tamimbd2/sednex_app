import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sednexapp/app/core/constants/url.dart';

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
      final response = await connect.post('${AppUrl.baseUrl}api/auth/login', {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      });

      var body = response.body;
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (_) {}
      }

      if (response.statusCode == 200 && body is Map) {
        final user = body['user'] ?? {};

        // Check if user account is active
        if (user['isActive'] == false) {
          Get.snackbar(
            'Account Suspended',
            'Your account is currently inactive. Please contact the administrator for more information.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFE53935),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
          return;
        }

        // Store token
        final token = body['token'] ?? '';

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
          backgroundColor: const Color(0xFF1E63FF),
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
        backgroundColor: const Color(0xFF1E63FF),
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
