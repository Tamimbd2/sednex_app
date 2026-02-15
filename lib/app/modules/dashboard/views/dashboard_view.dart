import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

import 'package:google_fonts/google_fonts.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFFC62828), // Deep Red matching CreatePost
        elevation: 0,
        leadingWidth: 0,
        titleSpacing: 16,
        title: Image.asset(
          'assets/logo/logowithtext.png',
          height: 32,
          fit: BoxFit.contain,
        ),
        actions: [
          // Notification Icon with Badge
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/Icon.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD700), // Gold/Yellow badge
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '3',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Profile Picture
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, color: Colors.grey),
              // backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'), // Use this if online
            ),
          ),
        ],
      ),
      body: Obx(() => _getPage(controller.currentIndex.value)),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
    return const Center(
      child: Text(
        'Home',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
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
                    color: Colors.black.withOpacity(0.05),
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
    return const Center(
      child: Text(
        'Profile',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC143C).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/createpost');
        },
        backgroundColor: const Color(0xFFDC143C),
        elevation: 0,
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() => Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
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
          const SizedBox(width: 64), // Space for FAB
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
