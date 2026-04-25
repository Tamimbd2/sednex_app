import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/url.dart';
import '../controllers/editprofile_controller.dart';

class EditprofileView extends GetView<EditprofileController> {
  const EditprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
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
                child: GestureDetector(
                  onTap: controller.pickImage,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Obx(() => Container(
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
                          child: controller.selectedImageBytes.value != null
                              ? ClipOval(
                                  child: Image.memory(
                                    controller.selectedImageBytes.value!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : (controller.currentAvatar.value.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        controller.currentAvatar.value.startsWith('http')
                                            ? controller.currentAvatar.value
                                            : "${AppUrl.baseUrl}${controller.currentAvatar.value}",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.person, size: 50, color: Colors.grey),
                                      ),
                                    )
                                  : const Icon(Icons.person, size: 50, color: Colors.grey)),
                        ),
                      )),
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
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: controller.pickImage,
                child: Text(
                  'Change Photo',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1E63FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const SizedBox(height: 16),
              _buildLabel('Full Name'),
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
                maxLines: 3,
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildLabel('Birth Date'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.birthDateController,
                          hint: 'YYYY-MM-DD',
                          icon: Icons.calendar_today_outlined,
                          readOnly: true,
                          onTap: controller.chooseDate,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildLabel('Gender'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: controller.selectedGender,
                          hint: 'Select Gender',
                          icon: Icons.people_outline,
                          items: ['Male', 'Female', 'Other'],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildLabel('Marital Status'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: controller.selectedMaritalStatus,
                          hint: 'Select Status',
                          items: ['Single', 'Married', 'Divorced', 'Widowed'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildLabel('Blood Group'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: controller.selectedBloodGroup,
                          hint: 'Select Group',
                          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildLabel('Job Title'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.jobTitleController,
                hint: 'Software Engineer',
                icon: Icons.work_outline,
              ),

              const SizedBox(height: 16),
              _buildLabel('Company Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.companyNameController,
                hint: 'Example Ltd.',
                icon: Icons.business_outlined,
              ),

              const SizedBox(height: 16),
              _buildLabel('Work Address'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.workAddressController,
                hint: 'Office Location',
                icon: Icons.store_outlined,
              ),

              const SizedBox(height: 16),
              _buildLabel('Website Link'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.websiteLinkController,
                hint: 'https://example.com',
                icon: Icons.link,
              ),

              const SizedBox(height: 16),
              _buildLabel('Current Address'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.currentAddressController,
                hint: 'Street, House No',
                icon: Icons.map_outlined,
              ),

              const SizedBox(height: 16),
              _buildLabel('Country/Location'),
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
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Save Changes',
                          style: GoogleFonts.poppins(
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

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          color: const Color(0xFF1E63FF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: const Color(0xFF495565),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required RxString value,
    required String hint,
    required List<String> items,
    IconData? icon,
  }) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E8F5), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value.value) ? value.value : null,
          hint: Text(hint, style: GoogleFonts.poppins(color: const Color(0xFF9CA3AF), fontSize: 16)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: const Color(0xFF9CA3AF), size: 22),
                    const SizedBox(width: 12),
                  ],
                  Text(item, style: GoogleFonts.poppins(color: const Color(0xFF101727), fontSize: 16)),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              value.value = newValue;
            }
          },
        ),
      ),
    ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
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
        prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF9CA3AF), size: 22) : null,
        filled: true,
        fillColor: const Color(0xFFF3F8FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE1E8F5), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1E63FF), width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

