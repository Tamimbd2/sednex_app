import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/url.dart';
import '../controllers/profileinfodetails_controller.dart';

class ProfileinfodetailsView extends GetView<ProfileinfodetailsController> {
  const ProfileinfodetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1E63FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Obx(() {
                    final imgUrl = controller.profileImage.value;
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFFF3F4F6),
                        backgroundImage: imgUrl.isNotEmpty
                            ? (imgUrl.startsWith('http')
                                ? NetworkImage(imgUrl)
                                : NetworkImage("${AppUrl.baseUrl}$imgUrl"))
                            : null,
                        child: imgUrl.isEmpty
                            ? const Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  Obx(() => Text(
                        controller.name.value,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      )),
                  Obx(() => Text(
                        controller.email.value,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Personal Information
            _buildSectionTitle('Personal Information'),
            const SizedBox(height: 12),
            Container(
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  Obx(() => _buildInfoItem(Icons.location_on_outlined, 'Birth Address', controller.birthAddress.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.home_outlined, 'Current Address', controller.currentAddress.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.calendar_today_outlined, 'Birth Date', controller.birthDate.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.person_outline, 'Gender', controller.gender.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.favorite_border, 'Marital Status', controller.maritalStatus.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.flag_outlined, 'Nationality', controller.nationality.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.opacity, 'Blood Group', controller.bloodGroup.value)),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            // Professional Information
            _buildSectionTitle('Professional Information'),
            const SizedBox(height: 12),
            Container(
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  Obx(() => _buildInfoItem(Icons.work_outline, 'Job Title', controller.jobTitle.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.business_outlined, 'Company Name', controller.companyName.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.store_outlined, 'Work Address', controller.workAddress.value)),
                ],
              ),
            ),

            const SizedBox(height: 32),
            // Contact Information
            _buildSectionTitle('Contact Information'),
            const SizedBox(height: 12),
            Container(
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  Obx(() => _buildInfoItem(Icons.phone_outlined, 'Phone Number', controller.phone.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.email_outlined, 'Email Address', controller.email.value)),
                  const Divider(height: 1, indent: 60),
                  Obx(() => _buildInfoItem(Icons.link_outlined, 'Website Link', controller.websiteLink.value)),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF64748B)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'N/A',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
