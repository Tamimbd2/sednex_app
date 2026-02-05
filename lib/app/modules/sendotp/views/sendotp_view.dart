import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/sendotp_controller.dart';

class SendotpView extends GetView<SendotpController> {
  const SendotpView({super.key});
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
                const SizedBox(height: 120),
                // Title
                Text(
                  'Forgot Password',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
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
                    'Enter your email or phone number to reset your password',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6E6E6E),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // Input Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email or phone number',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1C1C1C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.emailController,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: const Color(0xFF1D2838),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email or phone number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: GoogleFonts.poppins(
                          color: const Color(0x7F0A0A0A),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF6E6E6E), size: 20),
                        filled: true,
                        fillColor: AppColors.inputField.withOpacity(0.5),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white, width: 1.15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white, width: 1.15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey, width: 1.15),
                        ),
                        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                // Send Code Button
                PrimaryButton(
                  title: 'Send Code',
                  onTap: () => controller.sendCode(),
                  width: double.infinity,
                  height: 56,
                ),
                const SizedBox(height: 40),
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password? ',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6E6E6E),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Back to Login',
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
