import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
            // Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                children: [
                  // Avatar with Gradient Border
                  Container(
                    padding: const EdgeInsets.all(3), // Border width
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF6366), Color(0xFFE7000A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Obx(() {
                      final imgUrl = controller.userProfileImage.value;
                      return CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: imgUrl != null
                            ? NetworkImage(imgUrl)
                            : null,
                        child: imgUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey,
                              )
                            : null,
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  // Name
                  Obx(() => Text(
                    controller.userName.value.isNotEmpty
                        ? controller.userName.value
                        : 'User',
                    style: GoogleFonts.arimo(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF101727),
                    ),
                  )),
                  const SizedBox(height: 4),
                  // Handle
                  Obx(() => Text(
                    controller.userHandle.value.isNotEmpty
                        ? controller.userHandle.value
                        : '',
                    style: GoogleFonts.arimo(
                      fontSize: 14,
                      color: const Color(0xFF697282),
                    ),
                  )),
                  const SizedBox(height: 12),
                  // Email as bio fallback until real bio field is added
                  Obx(() => Text(
                    controller.userEmail.value.isNotEmpty
                        ? controller.userEmail.value
                        : '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.arimo(
                      fontSize: 14,
                      color: const Color(0xFF495565),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // "Other settings" Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Other settings',
                style: GoogleFonts.arimo(
                  fontSize: 14,
                  color: const Color(0xFF495565),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Settings Group 1
            _buildSettingsGroup([
              _buildSettingsItem(
                'Shop',
                'assets/profile/shop.svg',
                onTap: () => Get.toNamed('/shop'),
              ),
              _buildSettingsItem('My Post', 'assets/profile/post.svg'),
              _buildSettingsItem('Cart', 'assets/profile/cart.svg'),
              _buildSettingsItem(
                'Edit Profile', 
                'assets/profile/editprofile.svg',
                onTap: () => Get.toNamed('/editprofile'),
              ),
              _buildSettingsItem(
                'Password', 
                'assets/profile/password.svg',
                onTap: () => Get.toNamed('/change-password'),
              ),
              _buildSettingsItem(
                'Language', 
                'assets/profile/language.svg',
                onTap: () => Get.toNamed('/language'),
              ),
              _buildSettingsItem('Notification', 'assets/profile/notifications.svg'),
              _buildSettingsItem('Saved Post', 'assets/profile/savepost.svg', isLast: true),
            ]),
            
            const SizedBox(height: 24),

            // Settings Group 2
            _buildSettingsGroup([
              _buildSettingsItem(
                'Terms and Condition', 
                'assets/profile/termsandconditions.svg',
                onTap: () => Get.toNamed('/termsandcondition'),
              ),
              _buildSettingsItem(
                'Help/FAQ', 
                'assets/profile/help.svg',
                onTap: () => Get.toNamed('/help'),
              ),
              _buildSettingsItem(
                'About Us', 
                'assets/profile/aboutus.svg',
                onTap: () => Get.toNamed('/aboutus'),
              ),
              _buildSettingsItem(
                'Logout', 
                'assets/profile/logout.svg', 
                isLast: true, 
                isDestructive: true,
                onTap: () {
                  Get.defaultDialog(
                    title: 'Logout',
                    middleText: 'Are you sure you want to log out?',
                    textConfirm: 'Yes',
                    textCancel: 'No',
                    confirmTextColor: Colors.white,
                    buttonColor: const Color(0xFFFA2B36),
                    cancelTextColor: const Color(0xFF101727),
                    onConfirm: () {
                      Get.back(); // Close dialog first
                      controller.logout();
                    },
                    onCancel: () => Get.back(),
                    titlePadding: const EdgeInsets.only(top: 24, bottom: 12),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsItem(String title, String iconPath, {bool isLast = false, bool isDestructive = false, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: isDestructive ? null : null, // SVG handles color or allow original
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.arimo(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDestructive ? const Color(0xFFFA2B36) : const Color(0xFF101727),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 20,
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

