import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/community_controller.dart';
import 'communityprofiledetails.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'community'.tr,
          style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (val) => controller.searchMembers(val),
              decoration: InputDecoration(
                hintText: 'search_members_hint'.tr,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[500],
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
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF2C2C2C),
                fontWeight: FontWeight.w500,
              ),
              cursorColor: const Color(0xFF1E63FF),
            ),
          ),
          const SizedBox(height: 8),
          // Members Count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.people_outline, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    '${controller.filteredMembers.length} ${'members_found'.tr}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Members List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
                );
              }

              if (controller.filteredMembers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_members_found'.tr,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = controller.filteredMembers[index];
                  return _buildMemberCard(member);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(dynamic member) {
    final name = (member['name'] ?? 'unknown'.tr).toString();
    final location = (member['country'] ?? 'unknown'.tr).toString();
    final image = (member['profileImage'] ?? '').toString();
    final isVerified = member['isVerified'] == true || member['verified'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Get.to(() => CommunityProfileDetailsView(member: member));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                backgroundImage: image.isNotEmpty ? CachedNetworkImageProvider(image) : null,
                child: image.isEmpty
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: AppTextStyles.headingSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Name and Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: Color(0xFF1E63FF), size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      location,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
