import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../profile/views/profile_view.dart';
import '../../Shop/views/shop_view.dart';
import '../../notifications/controllers/notifications_controller.dart';
import 'home_page_content.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Obx(() {
          // Show header consistently across all tabs

          return Container(
            height: 110,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: const Color(0xFF1E63FF),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E63FF).withValues(alpha: 0.30),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Logo
                  Image.asset(
                    'assets/logo/Sednex Website Logo Eng@3x.png',
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  // Notification Icon with Badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.0),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Get.find<NotificationsController>().markAllAsRead();
                            Get.toNamed(Routes.NOTIFICATIONS);
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/Icon.svg',
                            width: 26,
                            height: 28,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        final nController = Get.find<NotificationsController>();
                        final unreadCount = nController.unreadCount;
                        if (unreadCount == 0) return const SizedBox.shrink();
                        
                        return Positioned(
                          right: 5,
                          top: 5,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.crimson,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                unreadCount > 9 ? '9+' : unreadCount.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Profile Picture
                  GestureDetector(
                    onTap: () => controller.changePage(3),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: controller.currentIndex.value == 3
                              ? AppColors.crimson
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Obx(() {
                        final imgUrl = controller.userProfileImage.value;
                        return CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey[100],
                          backgroundImage: imgUrl != null
                              ? CachedNetworkImageProvider(imgUrl)
                              : null,
                          child: imgUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Color(0xFF9CA3AF),
                                )
                              : null,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      body: Obx(() => _getPage(controller.currentIndex.value)),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildSearchPage();
      case 2:
        return _buildShopPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return const HomePageContent();
  }

  Widget _buildSearchPage() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (val) => controller.searchQuery.value = val,
              decoration: InputDecoration(
                hintText: 'Search Anything...',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey[500],
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
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
              style: GoogleFonts.inter(
                color: const Color(0xFF2C2C2C),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: const Color(0xFF1E63FF),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Text(
                'Search Anything',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopPage() {
    return const ShopContent();
  }

  Widget _buildProfilePage() {
    return ProfileView();
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 15,
              offset: const Offset(0, -5), // Negative Y for bottom bar to show shadow upwards
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  iconPath: 'assets/nav/home.svg',
                  index: 0,
                  isActive: controller.currentIndex.value == 0,
                ),
                _buildNavItem(
                  iconPath: 'assets/nav/search.svg',
                  index: 1,
                  isActive: controller.currentIndex.value == 1,
                ),
                // Center + button
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.CREATEPOST),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.crimson,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, size: 28, color: Colors.white),
                  ),
                ),
                _buildNavItem(
                  iconPath: 'assets/profile/shop.svg', // Moved Shop to nav
                  index: 2,
                  isActive: controller.currentIndex.value == 2,
                ),
                _buildNavItem(
                  iconPath: 'assets/nav/profile.svg',
                  index: 3,
                  isActive: controller.currentIndex.value == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isActive ? const Color(0xFF1E63FF) : const Color(0xFF8F95A1),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
