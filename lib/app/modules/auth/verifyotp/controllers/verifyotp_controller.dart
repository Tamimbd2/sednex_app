import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/api_service.dart';

class VerifyotpController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final focusedIndex = 0.obs;
  final isLoading = false.obs;
  
  // Timer related
  final resendSeconds = 30.obs;
  final canResend = true.obs;
  Timer? _timer;
  
  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments ?? '';
    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(() {
        if (focusNodes[i].hasFocus) {
          focusedIndex.value = i;
        }
      });
    }
    startResendTimer();
  }

  void startResendTimer() {
    canResend.value = false;
    resendSeconds.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        canResend.value = true;
        _timer?.cancel();
      }
    });
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
    if (email.isEmpty || !canResend.value) return;
    
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
        startResendTimer();
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
    _timer?.cancel();
    super.onClose();
  }
}
