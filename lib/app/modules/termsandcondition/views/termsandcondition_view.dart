import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/termsandcondition_controller.dart';

class TermsandconditionView extends GetView<TermsandconditionController> {
  const TermsandconditionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Terms and Conditions',
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
              Text(
                'Last updated: December 13, 2025',
                style: GoogleFonts.arimo(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please read these terms and conditions carefully before using our mobile application.',
                style: GoogleFonts.arimo(
                  color: const Color(0xFF495565),
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              
              _buildSection(
                '1. Acceptance of Terms',
                'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
              ),
              
              _buildSection(
                '2. User Account',
                'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account or password.\n\nYou must notify us immediately of any unauthorized use of your account or any other breach of security.',
              ),

              _buildSection(
                '3. Privacy Policy',
                'Your use of this application is also governed by our Privacy Policy. We collect, use, and protect your personal information in accordance with applicable data protection laws.\n\nBy using this application, you consent to our collection and use of personal data as outlined in our Privacy Policy.',
              ),

              _buildSection(
                '4. User Content',
                'Users may post, upload, or submit content to the application. You retain ownership of any content you submit, however you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, and distribute your content.\n\nYou are solely responsible for the content you post and agree not to post content that is illegal, offensive, or infringes on the rights of others.',
              ),

              _buildSection(
                '5. Prohibited Activities',
                'You agree not to engage in any of the following prohibited activities:',
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.arimo(
              color: const Color(0xFF101727),
              fontSize: 18,
              fontWeight: FontWeight.w600, // Semibold for headers
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.arimo(
              color: const Color(0xFF495565),
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
