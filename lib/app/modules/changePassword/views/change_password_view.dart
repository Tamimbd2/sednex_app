import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controllers/change_password_controller.dart';
import '../../../core/theme/app_text_styles.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very light grey bg
      appBar: AppBar(
        title: Text(
          'reset_password'.tr,
          style: AppTextStyles.appBarTitle,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF), // Light blue bg
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'password_info_msg'.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF1D4ED8), // Darker blue text
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Current Password
              _buildLabel('current_password_label'.tr),
              const SizedBox(height: 8),
              Obx(() => _buildPasswordField(
                controller: controller.currentPasswordController,
                hintText: 'enter_current_password'.tr,
                isVisible: controller.isCurrentPasswordVisible.value,
                onToggleVisibility: controller.toggleCurrentPasswordVisibility,
              )),
              
              const SizedBox(height: 24),

              // New Password
              _buildLabel('new_password_label'.tr),
              const SizedBox(height: 8),
              Obx(() => _buildPasswordField(
                controller: controller.newPasswordController,
                hintText: 'enter_new_password'.tr,
                isVisible: controller.isNewPasswordVisible.value,
                onToggleVisibility: controller.toggleNewPasswordVisibility,
              )),

              const SizedBox(height: 24),

              // Confirm New Password
              _buildLabel('confirm_password_label'.tr),
              const SizedBox(height: 8),
              Obx(() => _buildPasswordField(
                controller: controller.confirmNewPasswordController,
                hintText: 're_enter_new_password'.tr,
                isVisible: controller.isConfirmNewPasswordVisible.value,
                onToggleVisibility: controller.toggleConfirmNewPasswordVisibility,
              )),

              const SizedBox(height: 48),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E63FF),
                    disabledBackgroundColor: const Color(0xFF1E63FF).withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'update_password'.tr,
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        color: const Color(0xFF495565),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: AppTextStyles.bodyMedium.copyWith(
        color: const Color(0xFF101727),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: const Color(0xFF9CA3AF),
          fontSize: 15,
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF), size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF9CA3AF),
            size: 20,
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E63FF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}

