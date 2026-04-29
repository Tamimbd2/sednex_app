import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../controllers/aboutus_controller.dart';

class AboutusView extends GetView<AboutusController> {
  const AboutusView({super.key});

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
          'about_us'.tr,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('our_team'.tr),
              const SizedBox(height: 16),

              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: Color(0xFFE7000A),
                      ),
                    ),
                  );
                }

                if (controller.teamMembers.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'no_team_found'.tr,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  );
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(controller.teamMembers.length, (
                      index,
                    ) {
                      final member = controller.teamMembers[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == controller.teamMembers.length - 1
                              ? 0
                              : 24.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar with Red Border
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  image: member.image.isNotEmpty
                                      ? DecorationImage(
                                          image: CachedNetworkImageProvider(member.image),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: member.image.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: const Color(0xFF101727),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    member.designation,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: const Color(0xFF495565),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    member.about,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              }),

              Obx(() {
                final contact = controller.contactData;
                if (contact.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    _buildSectionTitle('contact_us'.tr),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          if (contact['email'] != null)
                            _buildContactItem(
                              Icons.email_outlined,
                              contact['email'],
                            ),
                          if (contact['email'] != null &&
                              contact['mobile'] != null)
                            const Divider(
                              height: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color(0xFFF2F4F6),
                            ),
                          if (contact['mobile'] != null)
                            _buildContactItem(
                              Icons.phone_outlined,
                              contact['mobile'],
                              subtitle: 'WhatsApp',
                            ),
                          if (contact['mobile'] != null &&
                              contact['website'] != null)
                            const Divider(
                              height: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Color(0xFFF2F4F6),
                            ),
                          if (contact['website'] != null)
                            _buildContactItem(
                              Icons.language,
                              contact['website'],
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 48),
              Center(
                child: Text(
                  'Copyright © Sednex 2025',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bodyLarge.copyWith(
        color: const Color(0xFF495565),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF495565), size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF101727),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
