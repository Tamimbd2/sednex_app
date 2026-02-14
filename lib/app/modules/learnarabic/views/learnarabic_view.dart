import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/learnarabic_controller.dart';

class LearnarabicView extends GetView<LearnarabicController> {
  const LearnarabicView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Learn Arabic',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search word (Bangla / Arabic / English)',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[400],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          // Category Tabs
          SizedBox(
            height: 40,
            child: Obx(() => ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _buildTab('Daily Life', 0),
                const SizedBox(width: 8),
                _buildTab('Work', 1),
                const SizedBox(width: 8),
                _buildTab('Shopping', 2),
                const SizedBox(width: 8),
                _buildTab('Restaurant', 3),
                const SizedBox(width: 8),
                _buildTab('Transport', 4),
                const SizedBox(width: 8),
                _buildTab('Hospital', 5),
                const SizedBox(width: 8),
                _buildTab('Emergency', 6),
                const SizedBox(width: 8),
                _buildTab('Documents', 7),
                const SizedBox(width: 8),
                _buildTab('Banking', 8),
                const SizedBox(width: 8),
                _buildTab('Mosque', 9),
              ],
            )),
          ),
          const SizedBox(height: 16),
          // Word Cards
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.getCurrentWords().length,
              itemBuilder: (context, index) {
                final word = controller.getCurrentWords()[index];
                return _buildWordCard(word);
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDC143C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFDC143C) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildWordCard(Map<String, String> word) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Left side - Bengali/English
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word['bengali']!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFDC143C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  word['english']!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Center - Arabic
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  word['arabic']!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  word['pronunciation']!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Right side - Audio icon
          IconButton(
            icon: Icon(
              Icons.volume_up_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
            onPressed: () {
              Get.snackbar(
                'Audio',
                'Playing pronunciation...',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
              );
            },
          ),
        ],
      ),
    );
  }
}
