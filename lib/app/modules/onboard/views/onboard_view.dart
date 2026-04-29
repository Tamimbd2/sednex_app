import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/primary_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/onboard_controller.dart';

class OnboardView extends GetView<OnboardController> {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> onboardingData = [
      {
        'image': 'assets/onboarding/ONB-1-1.svg',
        'title': 'onboard_title_1'.tr,
        'subtitle': 'onboard_subtitle_1'.tr,
        'description': 'onboard_desc_1'.tr,
      },
      {
        'image': 'assets/onboarding/ONB-1-2.svg',
        'title': 'onboard_title_2'.tr,
        'subtitle': 'onboard_subtitle_2'.tr,
        'description': 'onboard_desc_2'.tr,
      },
      {
        'image': 'assets/onboarding/ONB-1-3.svg',
        'title': 'onboard_title_3'.tr,
        'subtitle': 'onboard_subtitle_3'.tr,
        'description': 'onboard_desc_3'.tr,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        // Image Container
                        Center(
                          child: SvgPicture.asset(
                            onboardingData[index]['image']!,
                            key: ValueKey(onboardingData[index]['image']),
                            height: Get.height * 0.35,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Text Content
                        Text(
                          onboardingData[index]['title']!,
                          style: AppTextStyles.headingMedium.copyWith(
                            color: const Color(0xFF001A4F),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          onboardingData[index]['subtitle']!,
                          style: AppTextStyles.subHeadingLarge.copyWith(
                            color: const Color(0xFF001A4F).withValues(alpha: 0.8),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          onboardingData[index]['description']!,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: const Color(0xFF1E293B),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Footer (Indicator + Button)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                          width: controller.currentPage.value == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                        () => PrimaryButton(
                          onTap: controller.nextPage,
                          title:
                              controller.currentPage.value ==
                                  onboardingData.length - 1
                              ? 'get_started'.tr
                              : 'next'.tr,
                          width: 160,
                          borderRadius: 15,
                          textStyle: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
