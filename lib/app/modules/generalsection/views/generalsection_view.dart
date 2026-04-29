import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/generalsection_controller.dart';
import 'generalsection_details.dart';

class GeneralSectionView extends GetView<GeneralSectionController> {
  const GeneralSectionView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          controller.slug.tr,
          style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF3575FF),
            height: 1,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (val) => controller.searchQuery.value = val,
              decoration: InputDecoration(
                hintText: '${'search'.tr} ${controller.slug.tr}...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[500],
                  fontSize: 15,
                ),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[500], size: 22),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
                ),
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF2C2C2C),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: const Color(0xFF1E63FF),
            ),
          ),
          const SizedBox(height: 24),

          // Heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${'all'.tr} ${controller.slug.tr}',
              style: AppTextStyles.headingSmall.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Grid
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value && controller.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (controller.filteredItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'no_entries_found'.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 15,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: controller.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredItems[index];
                    return _buildSectionItemCard(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionItemCard(SectionItem item) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const GeneralSectionDetailsView(),
          arguments: {
            'item': item,
            'title': controller.title,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            SizedBox(
              width: 50,
              height: 50,
              child: item.image.isNotEmpty
                  ? Image.network(
                      item.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.business,
                          color: Colors.grey,
                          size: 30,
                        );
                      },
                    )
                  : const Icon(
                      Icons.business,
                      color: Colors.grey,
                      size: 30,
                    ),
            ),
            const SizedBox(height: 8),
            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                item.name,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
