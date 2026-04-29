import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controllers/termsandcondition_controller.dart';
import '../../../core/theme/app_text_styles.dart';

class TermsandconditionView extends GetView<TermsandconditionController> {
  const TermsandconditionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E63FF),
                Color(0xFF3575FF),
              ],
            ),
          ),
        ),
        title: Text(
          'terms_condition'.tr,
          style: AppTextStyles.headingMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        centerTitle: true,
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
                'no_terms_found'.tr,
                style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF697282)),
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
                    '${'last_updated_label'.tr}: ${controller.lastUpdated.value!.day} ${_getMonthName(controller.lastUpdated.value!.month)}, ${controller.lastUpdated.value!.year}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  'terms_intro'.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF495565),
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
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF101727),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF495565),
              height: 1.6,
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
