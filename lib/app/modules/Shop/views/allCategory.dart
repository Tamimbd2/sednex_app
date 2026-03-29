import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';
import '../controllers/shop_controller.dart';

class AllCategoriesView extends GetView<ShopController> {
  const AllCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'All Categories',
          style: GoogleFonts.poppins(
            color: const Color(0xFF101727),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF101727)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.82,
        ),
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return GestureDetector(
            onTap: () => Get.toNamed(Routes.ALL_PRODUCTS, arguments: category['name']),
            child: _buildCategoryItem(category),
          );
        },
      )),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: category['color'], // Light pastel background
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                category['icon'],
                color: const Color(0xFF354152),
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          category['name'],
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: const Color(0xFF354152),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
