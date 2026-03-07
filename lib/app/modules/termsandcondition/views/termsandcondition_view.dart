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
          child: Container(color: const Color(0xFFF2F4F6), height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE7000A)),
            );
          }

          if (controller.terms.isEmpty) {
            return Center(
              child: Text(
                'No terms and conditions found.',
                style: GoogleFonts.arimo(color: const Color(0xFF697282)),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.lastUpdated.value != null)
                  Text(
                    'Last updated: ${controller.lastUpdated.value!.day} ${_getMonthName(controller.lastUpdated.value!.month)}, ${controller.lastUpdated.value!.year}',
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
                ...List.generate(controller.terms.length, (index) {
                  final term = controller.terms[index];
                  return _buildSection(
                    '${index + 1}. ${term.title}',
                    term.content,
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          );
        }),
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
            style: GoogleFonts.hindSiliguri(
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

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
