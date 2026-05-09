import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sednexapp/app/core/theme/app_text_styles.dart';
import '../controllers/community_feed_controller.dart';
import '../widgets/community_post_card.dart';

class CommunityFeedView extends GetView<CommunityFeedController> {
  final bool showAppBar;
  final bool showFAB;
  const CommunityFeedView({
    super.key,
    this.showAppBar = true,
    this.showFAB = true,
  });

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
      appBar: showAppBar
          ? AppBar(
              title: Text(
                'community_feed'.tr,
                style: AppTextStyles.appBarTitle,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
            )
          : null,
      floatingActionButton: showFAB
          ? FloatingActionButton(
              onPressed: () => Get.toNamed('/createpost'),
              backgroundColor: const Color(0xFF1E63FF),
              elevation: 4,
              child: SvgPicture.asset(
                'assets/homeicon/add-post.svg',
                width: 56, // Standard FAB size to fit the SVG circle
                height: 56,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF1E63FF),
          onRefresh: () => controller.refreshPosts(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Filter Chips (Always Visible)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _buildFilterChips(),
                ),
              ),

              Obx(() {
                if (controller.isLoading.value && controller.posts.isEmpty) {
                  return _buildSkeletonPosts();
                }

                if (!controller.isLoading.value && controller.posts.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
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
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CommunityPostCard(
                          post: controller.posts[index],
                          index: index,
                          controller: controller,
                        ),
                      );
                    }, childCount: controller.posts.length),
                  ),
                );
              }),

              // Loading more indicator
              Obx(() {
                if (!controller.isLoadingMore.value) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF1E63FF),
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
              }),

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonPosts() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[50]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Skeleton
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Content text lines
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Main Image Skeleton
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Footer actions skeleton
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 60,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }, childCount: 3),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1E63FF)
                      : Colors.transparent, // Red if selected
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: Colors.transparent,
                        ), // Clean look for unselected
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
