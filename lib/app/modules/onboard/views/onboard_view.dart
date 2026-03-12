import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/primary_button.dart';
import '../controllers/onboard_controller.dart';

class OnboardView extends GetView<OnboardController> {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> onboardingData = [
      {
        'image': 'assets/images/onboard1.png',
        'title': 'From jobs to healthcare — all in one place.',
        'description':
            'Access everything you need to manage your life, career, and wellbeing seamlessly.',
      },
      {
        'image': 'assets/images/onboard2.png',
        'title': 'Your finances, managed smarter.',
        'description':
            'Take control of your money with our smart budgeting and tracking tools.',
      },
      {
        'image': 'assets/images/onboards3.png',
        'title': 'Stay connected with your community.',
        'description':
            'Share moments, find support, and grow together with people who matter.',
      },
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, 0.00),
            end: Alignment(0.50, 1.00),
            colors: [Colors.white, Color(0xFFFFF4F6)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      // Image Container
                      Positioned(
                        left: 0,
                        top: 53,
                        right: 0,
                        child: Image.asset(
                          onboardingData[index]['image']!,
                          width: Get.width,
                          height: 485,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Text Content
                      Positioned(
                        left: 20,
                        right: 20,
                        top: 538,
                        child: Column(
                          children: [
                            Text(
                              onboardingData[index]['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF1C1C1C),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 1.33,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                onboardingData[index]['description']!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF6E6E6E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Footer (Indicator + Button)
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  // Page Indicator
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.currentPage.value == index ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? const Color(0xFF4A4A4A)
                                : const Color(0xFFC4C4C4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Action Button
                  Obx(
                    () => PrimaryButton(
                      onTap: controller.nextPage,
                      title: controller.currentPage.value ==
                              onboardingData.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
