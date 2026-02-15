import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/help_controller.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'FAQ / Help',
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
                'Frequently Asked Questions',
                style: GoogleFonts.arimo(
                  color: const Color(0xFF495565),
                  fontSize: 16,
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
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(() => Column(
                  children: List.generate(controller.faqs.length, (index) {
                    final faq = controller.faqs[index];
                    final isExpanded = faq['isExpanded'].value;
                    final isLast = index == controller.faqs.length - 1;

                    return Column(
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            key: Key('faq_$index'),
                            initiallyExpanded: isExpanded,
                            collapsedBackgroundColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            childrenPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                            leading: Icon(
                              Icons.help_outline,
                              color: const Color(0xFF495565),
                              size: 24,
                            ),
                            title: Text(
                              faq['question'],
                              style: GoogleFonts.arimo(
                                color: const Color(0xFF101727),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: const Color(0xFF697282),
                            ),
                            onExpansionChanged: (expanded) {
                              controller.toggleFaq(index);
                            },
                            children: [
                              Text(
                                faq['answer'],
                                style: GoogleFonts.arimo(
                                  color: const Color(0xFF697282),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          const Divider(height: 1, indent: 24, endIndent: 24, color: Color(0xFFF2F4F6)),
                      ],
                    );
                  }),
                )),
              ),

              const SizedBox(height: 32),

              // Contact Support Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6366), Color(0xFFE7000A)], // Red gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE7000A).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // White circle
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: Color(0xFFE7000A), // Red icon
                        size: 32,
                      ),
                    ), // Speech bubble icon approximation
                    const SizedBox(height: 16),
                    Text(
                      'Still Need Help?',
                      style: GoogleFonts.arimo(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Our support team is here to help you\n24/7',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.arimo(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: controller.contactSupport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFE7000A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                        child: Text(
                          'Contact Support',
                          style: GoogleFonts.arimo(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
