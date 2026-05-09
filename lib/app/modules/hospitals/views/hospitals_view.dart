import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/hospitals_controller.dart';
import 'hospitaldetails.dart';

class HospitalsView extends GetView<HospitalsController> {
  const HospitalsView({super.key});
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
          'hospitals'.tr,
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
                hintText: 'search_hospitals'.tr,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[500],
                  fontSize: 15,
                ),
                prefixIcon:
                    Icon(Icons.search_rounded, color: Colors.grey[500], size: 22),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                  borderSide:
                      BorderSide(color: Colors.grey[300]!, width: 1.5),
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

          // Hospitals Heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'all_hospitals'.tr,
              style: AppTextStyles.headingSmall.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Hospitals Grid
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value &&
                    controller.hospitals.isEmpty) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary));
                }

                if (controller.filteredHospitals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'no_hospitals_found'.tr,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: controller.filteredHospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = controller.filteredHospitals[index];
                    return _buildHospitalCard(hospital);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const HospitalDetailsView(),
          arguments: {
            'id': hospital.id,
            'name': hospital.name,
            'logoPath': hospital.image,
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
            // Hospital Logo
            SizedBox(
              width: 60,
              height: 60,
              child: hospital.image.isNotEmpty
                  ? Image.network(
                      hospital.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.local_hospital,
                          color: Colors.grey,
                          size: 40,
                        );
                      },
                    )
                  : const Icon(
                      Icons.local_hospital,
                      color: Colors.grey,
                      size: 40,
                    ),
            ),
            const SizedBox(height: 12),
            // Hospital Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                hospital.name,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 12,
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
