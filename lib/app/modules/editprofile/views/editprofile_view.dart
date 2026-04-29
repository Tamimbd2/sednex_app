import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../core/theme/app_colors.dart';
import '../../../core/constants/url.dart';
import '../controllers/editprofile_controller.dart';
import '../../../core/theme/app_text_styles.dart';

class EditprofileView extends GetView<EditprofileController> {
  const EditprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'edit_profile_title'.tr,
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E63FF),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  'change_photo'.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF1E63FF),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              const SizedBox(height: 16),
              _buildLabel('full_name'.tr),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.nameController,
                hint: 'enter_your_name'.tr,
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),
              _buildLabel('bio'.tr),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.bioController,
                hint: 'bio_hint'.tr,
                maxLines: 3,
              ),

              const SizedBox(height: 16),
              _buildLabel('phone_number'.tr),
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
                        _buildLabel('birth_date'.tr),
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
                        _buildLabel('gender'.tr),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: controller.selectedGender,
                          hint: 'select_gender'.tr,
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
                        _buildLabel('marital_status'.tr),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: controller.selectedMaritalStatus,
                          hint: 'select_status'.tr,
                          items: ['Single', 'Married', 'Divorced', 'Widowed'],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _buildLabel('blood_group'.tr),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: controller.selectedBloodGroup,
                          hint: 'select_group'.tr,
                          items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildLabel('job_title'.tr),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.jobTitleController,
                hint: 'Software Engineer',
                icon: Icons.work_outline,
              ),

              const SizedBox(height: 16),
              _buildLabel('company_name'.tr),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.companyNameController,
                hint: 'Example Ltd.',
                icon: Icons.business_outlined,
              ),

              const SizedBox(height: 16),
              _buildLabel('work_address'.tr),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.workAddressController,
                hint: 'Office Location',
                icon: Icons.store_outlined,
              ),

              const SizedBox(height: 16),
              _buildLabel('website_link'.tr),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.websiteLinkController,
                hint: 'https://example.com',
                icon: Icons.link,
              ),

              const SizedBox(height: 16),
              _buildLabel('current_address'.tr),
              const SizedBox(height: 8),
              _buildTextField(
                controller: controller.currentAddressController,
                hint: 'Street, House No',
                icon: Icons.map_outlined,
              ),

              const SizedBox(height: 16),
              _buildLabel('country_location'.tr),
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
                          'save_changes'.tr,
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: const Color(0xFF495565),
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
          hint: Text(hint, style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF9CA3AF))),
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
                  Text(item, style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF101727))),
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
      style: AppTextStyles.bodyMedium.copyWith(
        color: const Color(0xFF101727),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: const Color(0xFF9CA3AF),
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

