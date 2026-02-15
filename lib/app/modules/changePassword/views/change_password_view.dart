import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very light grey bg
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: GoogleFonts.arimo(
            color: const Color(0xFF101727),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF101727)),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFF2F4F6),
            height: 1.0,
          ),
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
                  'Your new password must be different from previously used passwords.',
                  style: GoogleFonts.arimo(
                    color: const Color(0xFF1D4ED8), // Darker blue text
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Current Password
              _buildLabel('Current Password'),
              const SizedBox(height: 8),
              Obx(() => _buildPasswordField(
                controller: controller.currentPasswordController,
                hintText: 'Enter current password',
                isVisible: controller.isCurrentPasswordVisible.value,
                onToggleVisibility: controller.toggleCurrentPasswordVisibility,
              )),
              
              const SizedBox(height: 24),

              // New Password
              _buildLabel('New Password'),
              const SizedBox(height: 8),
              Obx(() => _buildPasswordField(
                controller: controller.newPasswordController,
                hintText: 'Enter new password',
                isVisible: controller.isNewPasswordVisible.value,
                onToggleVisibility: controller.toggleNewPasswordVisibility,
              )),

              const SizedBox(height: 24),

              // Confirm New Password
              _buildLabel('Confirm New Password'),
              const SizedBox(height: 8),
              Obx(() => _buildPasswordField(
                controller: controller.confirmNewPasswordController,
                hintText: 'Re-enter new password',
                isVisible: controller.isConfirmNewPasswordVisible.value,
                onToggleVisibility: controller.toggleConfirmNewPasswordVisibility,
              )),

              const SizedBox(height: 48),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC143C), // Red
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Update Password',
                    style: GoogleFonts.arimo(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Forgot Password link
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to forgot password flow if needed
                  },
                  child: Text(
                    'Forgot current password?',
                    style: GoogleFonts.arimo(
                      color: const Color(0xFFDC143C), // Red
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
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
      style: GoogleFonts.arimo(
        color: const Color(0xFF495565),
        fontSize: 14,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: GoogleFonts.arimo(
          color: const Color(0xFF101727),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.arimo(
            color: const Color(0xFF9CA3AF),
            fontSize: 16,
          ),
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF)),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: const Color(0xFF9CA3AF),
            ),
            onPressed: onToggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
