import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Language',
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Info Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF), // Light blue
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Select your preferred language. The app will restart to apply changes.',
                        style: GoogleFonts.arimo(
                          color: const Color(0xFF1D4ED8), // Blue text
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Language List
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: List.generate(controller.languages.length, (index) {
                          final language = controller.languages[index];
                          final isLast = index == controller.languages.length - 1;
                          
                          return Column(
                            children: [
                              Obx(() {
                                final isSelected = controller.selectedLanguage.value == language['name'];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  title: Text(
                                    language['name']!,
                                    style: GoogleFonts.arimo(
                                      color: const Color(0xFF101727),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    language['native']!,
                                    style: GoogleFonts.arimo(
                                      color: const Color(0xFF697282), // Grey
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDC143C), // Red check
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.check, color: Colors.white, size: 16),
                                        )
                                      : Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                                          ),
                                        ),
                                  onTap: () => controller.selectLanguage(language['name']!),
                                );
                              }),
                              if (!isLast)
                                const Divider(height: 1, color: Color(0xFFF2F4F6), indent: 20, endIndent: 20),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Section
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.applyLanguage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC143C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Apply Language',
                        style: GoogleFonts.arimo(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Text(
                    'Currently selected: ${controller.selectedLanguage.value}',
                    style: GoogleFonts.arimo(
                      color: const Color(0xFF697282),
                      fontSize: 12,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

