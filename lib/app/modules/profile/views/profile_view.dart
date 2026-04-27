import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_pages.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/profile_controller.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New Redesigned Profile Header
              GestureDetector(
                onTap: () => Get.toNamed(Routes.PROFILEINFODETAILS),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar (No Camera Badge)
                      Stack(
                        children: [
                          Obx(() {
                            final imgUrl = controller.userProfileImage.value;
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[100]!,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: const Color(0xFFF3F4F6),
                                backgroundImage: imgUrl != null
                                    ? CachedNetworkImageProvider(imgUrl)
                                    : null,
                                child: imgUrl == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Info and Button
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                controller.userName.value.isNotEmpty
                                    ? controller.userName.value
                                    : 'profile'.tr,
                                style: AppTextStyles.headingSmall.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF111827),
                                ),
                              ),
                            ),
                            Obx(
                              () => Text(
                                controller.userEmail.value.isNotEmpty
                                    ? controller.userEmail.value
                                    : '',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 13,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: 140, // Match the compact button width
                              child: ElevatedButton(
                                onPressed: () => Get.toNamed('/editprofile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFF1E63FF,
                                  ), // Primary Blue Theme Color
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'edit_profile'.tr,
                                  style: AppTextStyles.button.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Warning Section
              Obx(() {
                if (controller.userWarning.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFEA580C),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.userWarning.value,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFF9A3412),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // "Other settings" Label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'other_settings'.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    color: const Color(0xFF495565),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Settings Group 1
              _buildSettingsGroup([
                _buildSettingsItem(
                  'my_post'.tr,
                  'assets/profile/post.svg',
                  onTap: () => Get.toNamed('/mypost'),
                ),
                Obx(
                  () => _buildSettingsItem(
                    'my_cart'.tr,
                    'assets/profile/cart.svg',
                    badgeCount: dashboardController.lovedProducts.length,
                    onTap: () => Get.toNamed(Routes.FAVORITES),
                  ),
                ),

                _buildSettingsItem(
                  'password'.tr,
                  'assets/profile/password.svg',
                  onTap: () => Get.toNamed('/change-password'),
                ),
                _buildSettingsItem(
                  'language'.tr,
                  'assets/profile/language.svg',
                  onTap: () => Get.toNamed('/language'),
                ),

                _buildSettingsItem(
                  'saved_post'.tr,
                  'assets/profile/savepost.svg',
                  onTap: () => Get.toNamed('/savepost'),
                ),
                _buildSettingsItem(
                  'saved_articles'.tr,
                  '', // No SVG path
                  icon: Icons.bookmark_border_rounded,
                  isLast: true,
                  onTap: () => Get.toNamed(Routes.SAVED_ARTICLES),
                ),
              ]),

              const SizedBox(height: 24),

              // Settings Group 2
              _buildSettingsGroup([
                _buildSettingsItem(
                  'terms_condition'.tr,
                  'assets/profile/termsandconditions.svg',
                  onTap: () => Get.toNamed('/termsandcondition'),
                ),
                _buildSettingsItem(
                  'help_faq'.tr,
                  'assets/profile/help.svg',
                  onTap: () => Get.toNamed('/help'),
                ),
                _buildSettingsItem(
                  'about_us'.tr,
                  'assets/profile/aboutus.svg',
                  onTap: () => Get.toNamed('/aboutus'),
                ),
                _buildSettingsItem(
                  'logout'.tr,
                  'assets/profile/logout.svg',
                  isLast: true,
                  isDestructive: true,
                  onTap: () {
                    Get.defaultDialog(
                      title: 'logout_confirm_title'.tr,
                      middleText: 'logout_confirm_desc'.tr,
                      textConfirm: 'yes'.tr,
                      textCancel: 'no'.tr,
                      confirmTextColor: Colors.white,
                      buttonColor: AppColors.primary,
                      cancelTextColor: const Color(0xFF101727),
                      onConfirm: () {
                        Get.back(); // Close dialog first
                        controller.logout();
                      },
                      onCancel: () => Get.back(),
                      titlePadding: const EdgeInsets.only(top: 24, bottom: 12),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      radius: 16,
                    );
                  },
                ),
              ]),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String iconPath, {
    bool isLast = false,
    bool isDestructive = false,
    VoidCallback? onTap,
    int? badgeCount,
    IconData? icon,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          leading: SizedBox(
            width: 24,
            height: 24,
            child: icon != null
                ? Icon(
                    icon,
                    size: 24,
                    color: isDestructive
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF354152),
                  )
                : SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    colorFilter: isDestructive ? null : null,
                  ),
          ),
          title: Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDestructive
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF101727), // Soft red for logout
            ),
          ),
          trailing: SizedBox(
            width: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (badgeCount != null && badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E63FF),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        badgeCount.toString(),
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
          onTap: onTap,
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: const Color(0xFFF2F4F6)),
          ),
      ],
    );
  }
}
