import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/embassy_controller.dart';
import 'embassydetails.dart';

class EmbassyView extends GetView<EmbassyController> {
  const EmbassyView({super.key});
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
          'embassies'.tr,
          style: AppTextStyles.appBarTitle,
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
                hintText: 'search_embassy_hint'.tr,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[500],
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
              ),
              cursorColor: const Color(0xFF1E63FF),
            ),
          ),
          const SizedBox(height: 24),

          // Embassy Heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'all_embassy'.tr,
              style: AppTextStyles.headingMedium.copyWith(color: Colors.black),
            ),
          ),
          const SizedBox(height: 16),

          // Embassy Grid
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value && controller.embassies.isEmpty) {
                  return Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (controller.filteredEmbassies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'no_embassy_found'.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: controller.filteredEmbassies.length,
                  itemBuilder: (context, index) {
                    final embassy = controller.filteredEmbassies[index];
                    return _buildEmbassyCard(embassy);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmbassyCard(Embassy embassy) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const EmbassyDetailsView(),
          arguments: {
            'embassy': embassy,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flag Logo
            SizedBox(
              width: 60,
              height: 60,
              child: embassy.icon.isNotEmpty
                  ? Image.network(
                      embassy.icon,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.flag,
                          color: Colors.grey,
                          size: 40,
                        );
                      },
                    )
                  : const Icon(
                      Icons.flag,
                      color: Colors.grey,
                      size: 40,
                    ),
            ),
            const SizedBox(height: 12),
            // Embassy Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                embassy.name,
                style: AppTextStyles.bodySmall.copyWith(
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
