import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_text_styles.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/learnarabic_controller.dart';

class LearnarabicView extends GetView<LearnarabicController> {
  const LearnarabicView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'learn_arabic'.tr,
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.categories.isEmpty) {
          return Center(
            child: Text(
              'no_categories_found'.tr,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 16),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'search_arabic_placeholder'.tr,
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[500],
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[500], size: 22),
                  filled: true,
                  fillColor: Colors.grey[100], // Minimalist soft grey background
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none, // No borders initially for a clean look
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5), // Subtle focus border
                  ),
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF2C2C2C),
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: const Color(0xFF1E63FF),
              ),
            ),
            const SizedBox(height: 24),
            // Category Tabs
            SizedBox(
              height: 40,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildTab('view_all'.tr, -1),
                    );
                  }
                  final category = controller.categories[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildTab(category.name, index - 1),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Word Cards
            Expanded(
              child: controller.currentWords.isEmpty
                  ? Center(
                      child: Text(
                        'no_words_found'.tr,
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.currentWords.length,
                      itemBuilder: (context, index) {
                        final word = controller.currentWords[index];
                        return _buildWordCard(word);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = controller.selectedTab.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildWordCard(LearnArabicWord word) {
    bool isArabicTextBengali = RegExp(r'[\u0980-\u09FF]').hasMatch(word.arabic);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // ~5% black shadow
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Arabic Word
            Text(
              word.arabic,
              textAlign: TextAlign.center,
              style: isArabicTextBengali
                  ? AppTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.2,
                    )
                  : GoogleFonts.amiri(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
              textDirection: isArabicTextBengali
                  ? TextDirection.ltr
                  : TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            // Pronunciation
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  word.pronunciation,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 12),
            // Translations Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bengali / Meaning
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'meaning'.tr,
                        style: AppTextStyles.label.copyWith(
                          color: Colors.grey[400],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        word.example.isNotEmpty ? word.example : 'N/A',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 35, color: const Color(0xFFF0F0F0)),
                const SizedBox(width: 12),
                // English
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'english'.tr,
                        style: AppTextStyles.label.copyWith(
                          color: Colors.grey[400],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        word.english,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
