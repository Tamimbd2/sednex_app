import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controllers/help_controller.dart';
import '../../../core/theme/app_text_styles.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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
          'faq_help_title'.tr,
          style: AppTextStyles.appBarTitle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'frequently_asked_questions'.tr,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF495565),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),

              // FAQ List Container
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
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE7000A),
                        ),
                      ),
                    );
                  }

                  if (controller.faqs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          'no_faqs_found'.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFF697282),
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: List.generate(controller.faqs.length, (index) {
                      final faq = controller.faqs[index];
                      final isExpanded = faq['isExpanded'].value;
                      final isLast = index == controller.faqs.length - 1;

                      return Column(
                        children: [
                          Theme(
                            data: Theme.of(
                              context,
                            ).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: Key('faq_${faq['id']}_$index'),
                              initiallyExpanded: isExpanded,
                              collapsedBackgroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              childrenPadding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                bottom: 24,
                              ),
                              leading: const Icon(
                                Icons.help_outline,
                                color: Color(0xFF495565),
                                size: 24,
                              ),
                              title: Text(
                                faq['question'],
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: const Color(0xFF101727),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: const Color(0xFF697282),
                              ),
                              onExpansionChanged: (expanded) {
                                controller.toggleFaq(index);
                              },
                              children: [
                                Text(
                                  faq['answer'],
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: const Color(0xFF697282),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isLast)
                            const Divider(
                              height: 1,
                              indent: 24,
                              endIndent: 24,
                              color: Color(0xFFF2F4F6),
                            ),
                        ],
                      );
                    }),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

