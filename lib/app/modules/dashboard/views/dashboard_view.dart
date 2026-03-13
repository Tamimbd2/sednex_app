import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../core/theme/app_colors.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../profile/views/profile_view.dart';
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
          // Hide AppBar only for Cart (index 2). Show for Home (0), Search (1), and Profile (3).
          if (controller.currentIndex.value == 2) return const SizedBox.shrink();
          return Container(
            height: 80,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
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
                    'assets/logo/textlogoblack.png',
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  // Notification Icon with Badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
                          icon: SvgPicture.asset(
                            'assets/icons/Icon.svg',
                            width: 22,
                            height: 22,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF6B7280),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.crimson,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.crimson.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                          backgroundImage: imgUrl != null ? NetworkImage(imgUrl) : null,
                          child: imgUrl == null
                              ? const Icon(Icons.person, size: 20, color: Color(0xFF9CA3AF))
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
        return _buildCartPage();
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: GoogleFonts.inter(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Search Anything',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFFC5A8A8), // Matching the screenshot's muted rose/brown color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartPage() {
    return const Center(
      child: Text(
        'Cart',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProfilePage() {
    return const ProfileView();
  }



  Widget _buildBottomNavigationBar() {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
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
                        color: AppColors.crimson.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildNavItem(
                iconPath: 'assets/nav/cart.svg',
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
    ));
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
              isActive ? const Color(0xFFDC143C) : const Color(0xFF8F95A1),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
