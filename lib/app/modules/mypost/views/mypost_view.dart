import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/mypost_controller.dart';
import '../../communityFeed/widgets/community_post_card.dart';
import '../../../core/theme/app_colors.dart';

class MypostView extends GetView<MypostController> {
  const MypostView({super.key});

  static final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Set up scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadMorePosts();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Posts',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF1E63FF),
          onRefresh: () => controller.refreshPosts(),
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
                    Icon(Icons.article_outlined, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'You haven\'t posted anything yet',
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
  
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Gap at the top
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                
                // Posts List (Sliver)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CommunityPostCard(
                            post: controller.posts[index],
                            index: index,
                            controller: controller, // Now accepts MypostController!
                          ),
                        );
                      },
                      childCount: controller.posts.length,
                    ),
                  ),
                ),
  
                // Loading more indicator
                if (controller.isLoadingMore.value)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E63FF)),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
  
                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
