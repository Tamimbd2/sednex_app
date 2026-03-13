import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/editprofile_controller.dart';

class EditprofileView extends GetView<EditprofileController> {
  const EditprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.arimo(
            color: const Color(0xFF101727),
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E63FF),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Change Photo',
                style: GoogleFonts.arimo(
                  color: const Color(0xFF1E63FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),

              // Form Fields
              _buildLabel('Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.nameController,
                hint: 'Enter your name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),
              _buildLabel('Bio'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.bioController,
                hint: 'Tell us about yourself...',
                maxLines: 4,
              ),

              const SizedBox(height: 16),
              _buildLabel('Phone Number'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.phoneController,
                hint: '+1 234 567 8900',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),
              _buildLabel('Location'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.locationController,
                hint: 'City, Country',
                icon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.arimo(
                      color: Colors.white,
                      fontSize: 16,
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.arimo(
          color: const Color(0xFF495565),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.arimo(
          color: const Color(0xFF101727),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.arimo(
            color: const Color(0xFF9CA3AF),
            fontSize: 16,
          ),
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF9CA3AF)) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

