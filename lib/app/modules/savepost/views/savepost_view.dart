import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/savepost_controller.dart';
import '../../communityFeed/widgets/community_post_card.dart';

class SavepostView extends GetView<SavepostController> {
  const SavepostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Saved Posts',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF1E63FF),
          onRefresh: () => controller.fetchSavedPosts(),
          child: Obx(() {
            if (controller.isLoading.value && controller.posts.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E63FF)),
                ),
              );
            }
  
            if (!controller.isLoading.value && controller.posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_outline, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'No saved posts found',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
  
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return CommunityPostCard(
                  post: controller.posts[index],
                  index: index,
                  controller: controller,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
