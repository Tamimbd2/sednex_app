import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LocalTourDetailsView extends StatelessWidget {
  const LocalTourDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the data passed from previous screen safely
    final args = Get.arguments is Map ? Map<String, dynamic>.from(Get.arguments as Map) : {};
    
    final String title = args['title'] ?? 'sednex_travel'.tr;
    final String image = args['image'] ?? '';
    final String locationDetails = args['locationDetails'] ?? '';
    final List<String> includedWithTickets = List<String>.from(args['includedWithTickets'] ?? []);
    final Map<String, dynamic> info = args['info'] is Map ? Map<String, dynamic>.from(args['info']) : {};

    final date = info['date'] ?? 'N/A';
    final distance = info['distance'] ?? 'N/A';
    final duration = info['duration'] ?? 'N/A';
    final ticketPrice = info['ticketPrice']?.toString() ?? '0';
    final ticketPriceTag = info['ticketPriceTag'] ?? '';
    final begins = info['begins'] ?? 'N/A';
    final returnTime = info['returnTime'] ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'sednex_travel'.tr,
          style: AppTextStyles.headingSmall.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main image
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
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
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.headingSmall.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locationDetails,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),

                  // Tour Information
                  Text(
                    'tour_information'.tr,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          Icons.calendar_today,
                          'date'.tr,
                          date,
                          const Color(0xFF4169E1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          Icons.location_on,
                          'distance'.tr,
                          distance,
                          const Color(0xFF00C853),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          Icons.access_time,
                          'duration'.tr,
                          duration,
                          const Color(0xFF9C27B0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          Icons.attach_money,
                          'ticket_price'.tr,
                          '$ticketPrice $ticketPriceTag',
                          const Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          Icons.wb_sunny,
                          'tour_begins'.tr,
                          begins,
                          const Color(0xFF00BCD4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          Icons.nightlight_round,
                          'return'.tr,
                          returnTime,
                          const Color(0xFFFF5722),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Included with Tickets
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'included_with_tickets'.tr,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (includedWithTickets.isNotEmpty)
                          ...includedWithTickets.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: _buildIncludedItem(
                                  Icons.check_circle,
                                  item,
                                  const Color(0xFF00C853),
                                ),
                              ))
                        else
                          Text(
                            "no_details_available".tr,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Location Details
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF1E63FF),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'location_details'.tr,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    locationDetails,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () async {
                      final Uri uri = Uri.parse('https://sednex.com/privacy-policy');
                      try {
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      } catch (e) {
                        debugPrint('Could not launch privacy policy: $e');
                      }
                    },
                    child: Text(
                      'privacy_policy'.tr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF4169E1),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Join Now Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        const contactNumber = "+8801787819588";
                        final formattedPhone = contactNumber.replaceAll('+', '');
                        final message = "Hello, I am interested in joining this travel package:\n\n*Tour Name:* $title\n*Date:* $date\n*Price:* $ticketPrice $ticketPriceTag\n\nPlease let me know the process.";
                        final encodedMessage = Uri.encodeComponent(message);
                        final uri = Uri.parse("https://wa.me/$formattedPhone?text=$encodedMessage");

                        try {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Could not open WhatsApp',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                            colorText: Colors.red,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'join_now_whatsapp'.tr,
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncludedItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }


}


