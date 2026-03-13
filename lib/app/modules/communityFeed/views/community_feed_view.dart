import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/community_feed_controller.dart';
import '../widgets/community_post_card.dart';

class CommunityFeedView extends GetView<CommunityFeedController> {
  const CommunityFeedView({super.key});

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
          'Community Feed',
          style: GoogleFonts.poppins(
            color: const Color(0xFF101727),
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
      body: RefreshIndicator(
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
                    'No posts found',
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
              // Filter Chips (Sliver)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _buildFilterChips(),
                ),
              ),
              
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
                          controller: controller,
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
                child: SizedBox(height: 16),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: controller.filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = controller.filters[index];
          return Obx(() {
            final isSelected = controller.selectedFilter.value == filter;
            return GestureDetector(
              onTap: () => controller.selectedFilter.value = filter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E63FF) : Colors.transparent, // Red if selected
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected ? null : Border.all(color: Colors.transparent), // Clean look for unselected
                ),
                alignment: Alignment.center,
                child: Text(
                  filter,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : const Color(0xFF354152),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

