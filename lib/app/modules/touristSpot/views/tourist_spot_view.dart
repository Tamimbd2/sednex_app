import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tourist_spot_controller.dart';
import 'toursitspotdetails.dart';

// ── Font Helper ──────────────────────────────────────────────────
TextStyle _getStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
  double? letterSpacing,
  String? text,
}) {
  bool isBangla = false;
  if (text != null) {
    isBangla = RegExp(r'[\u0980-\u09FF]').hasMatch(text);
  }
  return isBangla
      ? GoogleFonts.hindSiliguri(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
        )
      : GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
        );
}

class TouristSpotView extends GetView<TouristSpotController> {
  const TouristSpotView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'tourist_spots'.tr,
          style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.touristSpots.isEmpty) {
          return Center(
            child: Text(
              'no_tourist_spots_found'.tr,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.touristSpots.length,
          itemBuilder: (context, index) {
            final spot = controller.touristSpots[index];
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => const TouristSpotDetailsView(),
                  arguments: {
                    'title': spot.title,
                    'description': spot.description,
                    'image': spot.image,
                    'location': 'Bangladesh', // Fallback location since original API doesn't seem to have it
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: spot.image.isNotEmpty
                          ? Image.network(
                              spot.image,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    // Content
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spot.title,
                            style: AppTextStyles.headingSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2C2C2C),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            spot.description
                                .replaceAll(RegExp(r'<[^>]*>'), ' ')
                                .replaceAll('&nbsp;', ' ')
                                .replaceAll('&amp;', '&')
                                .replaceAll(RegExp(r'\s+'), ' ')
                                .trim(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12), // Small consistent gap
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'see_more'.tr,
                                  style: _getStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1E63FF),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 12,
                                  color: Color(0xFF1E63FF),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

