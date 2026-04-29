import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/primary_button.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // Title
                Text(
                  'create_account_title'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingLarge.copyWith(
                    color: const Color(0xFF1C1C1C),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  'create_account_subtitle'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF6E6E6E),
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: 40),
                // Full Name Field
                _buildInputField(
                  label: 'full_name'.tr,
                  hintText: 'your_name'.tr,
                  controller: controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'error_name_empty'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Email Field
                _buildInputField(
                  label: 'email'.tr,
                  hintText: 'enter_your_email'.tr,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, size: 20, color: Color(0xFF6E6E6E)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'error_email_empty'.tr;
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'error_email_invalid'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Country Field
                _buildCountryDropdown(),
                const SizedBox(height: 16),
                // Password Field
                Obx(() => _buildInputField(
                  label: 'password'.tr,
                  hintText: 'enter_password'.tr,
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                      color: const Color(0xFF6E6E6E),
                    ),
                    onPressed: () => controller.isPasswordVisible.toggle(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'error_password_empty_2'.tr;
                    }
                    if (value.length < 6) {
                      return 'error_password_length'.tr;
                    }
                    return null;
                  },
                )),
                const SizedBox(height: 40),
                // Sign Up Button
                PrimaryButton(
                  title: 'signup_btn'.tr,
                  onTap: () => controller.signup(),
                  width: double.infinity,
                  height: 56,
                ),
                const SizedBox(height: 25),
                // Or sign up with
                Text(
                  'or_sign_up_with'.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF99A1AE),
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 25),
                // Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      iconPath: 'assets/icons/google.svg',
                      onTap: () => controller.signInWithGoogle(),
                    ),
                    const SizedBox(width: 32),
                    _buildSocialButton(
                      iconPath: 'assets/icons/facebook.svg',
                      onTap: () => controller.signInWithFacebook(),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already_have_account'.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF6E6E6E),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.offNamed(Routes.SIGNIN),
                      child: Text(
                        'login'.tr,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF1C1C1C),
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          cursorColor: Colors.grey,
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF1D2838),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.hintText,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: false,
            contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.inputField, width: 1.15),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.15),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.15),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.15),
            ),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'country'.tr,
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF1C1C1C),
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
          initialValue: controller.selectedCountry.value,
          decoration: InputDecoration(
            filled: false,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.15),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.15),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.grey, width: 1.15),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0A0A0A)),
          items: controller.countries.map((String country) {
            return DropdownMenuItem<String>(
              value: country,
              child: Text(
                country,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0x7F0A0A0A),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              controller.selectedCountry.value = newValue;
            }
          },
        )),
      ],
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
