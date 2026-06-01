import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/localtour_controller.dart';
import 'toursdetails.dart';

class LocaltourView extends GetView<LocaltourController> {
  const LocaltourView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'sednex_travel'.tr,
          style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (controller.tours.isEmpty) {
            return Center(
              child: Text(
                'no_tours_found'.tr,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.tours.length,
            itemBuilder: (context, index) {
              final tour = controller.tours[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to tour details
                  Get.to(
                    () => const LocalTourDetailsView(),
                    arguments: {
                      'title': tour.title,
                      'image': tour.image,
                      'locationDetails': tour.locationDetails,
                      'includedWithTickets': tour.includedWithTickets,
                      'info': {
                        'date': tour.info.date,
                        'distance': tour.info.distance,
                        'duration': tour.info.duration,
                        'ticketPrice': tour.info.ticketPrice,
                        'ticketPriceTag': tour.info.ticketPriceTag,
                        'begins': tour.info.begins,
                        'returnTime': tour.info.returnTime,
                      },
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                      // Tour Image & Status Badge
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: tour.image.isNotEmpty
                                ? Image.network(
                                    tour.image,
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
                                          size: 60,
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
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          
                          // Status Badge
                          Positioned(
                            top: 12,
                            right: 12,
                            child: _buildStatusBadge(tour.tourStatus),
                          ),
                        ],
                      ),
                      
                      // Tour Details
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              tour.title,
                              style: AppTextStyles.headingSmall.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Date and Time
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 18,
                                  color: Color(0xFF1E63FF),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${tour.info.date} · ${tour.info.begins} - ${tour.info.returnTime}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Color(0xFF1E63FF),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tour.locationDetails,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
  
                            const SizedBox(height: 12),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 12),
  
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'see_details'.tr,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E63FF),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Color(0xFF1E63FF),
                                ),
                              ],
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
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'running':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        label = 'running'.tr;
        break;
      case 'upcoming':
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        label = 'upcoming'.tr;
        break;
      case 'completed':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        label = 'completed'.tr;
        break;
      default:
        bgColor = Colors.grey[200]!;
        textColor = Colors.grey[700]!;
        label = status.capitalizeFirst ?? status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


