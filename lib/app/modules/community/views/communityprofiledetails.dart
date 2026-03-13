import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityProfileDetailsView extends StatelessWidget {
  final dynamic member;
  const CommunityProfileDetailsView({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final name = (member['name'] ?? 'Unknown').toString();
    final email = (member['email'] ?? 'Not provided').toString();
    final country = (member['country'] ?? 'Unknown').toString();
    final bio = (member['bio'] ?? 'No bio available').toString();
    final phone = (member['phone'] ?? 'Not provided').toString();
    final role = (member['role'] ?? 'User').toString();
    final image = (member['profileImage'] ?? '').toString();

    // Primary Crimson Color used in the app
    const primaryColor = Color(0xFF1E63FF); 
    const textColor = Color(0xFF1F2937);
    const subTextColor = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.outfit(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image Section
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor.withValues(alpha: 0.1), width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                      child: image.isEmpty
                          ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: GoogleFonts.outfit(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              role.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryColor,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 30),
            
            // Info Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                   // About Section
                  _buildSectionHeader('Biography'),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      bio,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: subTextColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Details List
                  _buildSectionHeader('Contact Information'),
                  const SizedBox(height: 12),
                  _buildInfoTile(Icons.email_outlined, 'Email', email, primaryColor),
                  _buildInfoTile(Icons.phone_outlined, 'Phone', phone, primaryColor),
                  _buildInfoTile(Icons.location_on_outlined, 'Country', country, primaryColor),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF111827),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xFF1F2937),
                    fontWeight: FontWeight.w600,
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

