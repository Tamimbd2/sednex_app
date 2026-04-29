import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/verifyotp_controller.dart';

class VerifyotpView extends GetView<VerifyotpController> {
  const VerifyotpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              // Title
              Text(
                'verify_otp_title'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingLarge.copyWith(
                  color: const Color(0xFF1C1C1C),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'verify_otp_subtitle'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF6E6E6E),
                    height: 1.50,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _buildOTPField(context, index),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Resend Text
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'didnt_receive_code'.tr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF6E6E6E),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.canResend.value ? () => controller.resendCode() : null,
                    child: Text(
                      controller.canResend.value 
                          ? 'resend'.tr 
                          : '${'resend_in'.tr}${controller.resendSeconds.value}s',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: controller.canResend.value ? AppColors.primary : const Color(0xFF6E6E6E),
                        fontWeight: FontWeight.w500,
                        decoration: controller.canResend.value ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 50),
              // Verify Button
              Obx(() => controller.isLoading.value 
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      title: 'verify_code'.tr,
                      onTap: () => controller.verifyCode(),
                      width: double.infinity,
                      height: 56,
                    ),
              ),
              const SizedBox(height: 40),
              // Footer
              GestureDetector(
                onTap: () => Get.offAllNamed(Routes.SIGNIN),
                child: Text(
                  'back_to_login'.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField(BuildContext context, int index) {
    return Obx(() {
      final isFocused = controller.focusedIndex.value == index;
      final hasValue = controller.otpControllers[index].text.isNotEmpty;

      return SizedBox(
        width: 44,
        height: 54,
        child: TextFormField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          onChanged: (value) {
            if (value.length == 1 && index < 5) {
              FocusScope.of(context).requestFocus(controller.focusNodes[index + 1]);
            }
            if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(controller.focusNodes[index - 1]);
            }
            controller.focusedIndex.refresh();
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          cursorColor: AppColors.primary,
          style: AppTextStyles.headingMedium.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1C1C1C),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: isFocused ? Colors.white : const Color(0xFFF8FAFC),
            contentPadding: EdgeInsets.zero,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasValue 
                  ? AppColors.primary.withValues(alpha: 0.5) 
                  : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    });
  }
}
