import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/community_feed_controller.dart';

class CommunityFeedView extends GetView<CommunityFeedController> {
  const CommunityFeedView({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: CustomScrollView(
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
            sliver: Obx(() => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildPostCard(context, index),
                  );
                },
                childCount: controller.posts.length,
              ),
            )),
          ),
        ],
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
                  color: isSelected ? const Color(0xFFDC143C) : Colors.transparent, // Red if selected
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

  Widget _buildPostCard(BuildContext context, int index) {
    final post = controller.posts[index];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(post['avatar']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['name'],
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF101727),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2), // Small spacing
                    Row(
                      children: [
                        Text(
                          post['time'],
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF697282),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (post['category'] != null) ...[
                          const SizedBox(width: 8),
                          _buildCategoryTag(post['category']),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              _buildMoreOptionsButton(),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Content
          Text(
            post['content'],
            style: GoogleFonts.poppins(
              color: const Color(0xFF354152),
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          
          const SizedBox(height: 12),

          if (post['images'] != null && (post['images'] as List).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPostImages(post['images']),
            ),

          const SizedBox(height: 4),
          
              // Footer
          Row(
            children: [
              // Like
              GestureDetector(
                onTap: () => controller.toggleLike(index),
                child: Container(
                  color: Colors.transparent, // Expand hit area
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 24, // Increased size
                        color: post['isLiked'] ? const Color(0xFFDC143C) : Colors.grey[400], 
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post['likes']}',
                        style: GoogleFonts.poppins(
                          color: post['isLiked'] ? const Color(0xFFDC143C) : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Comment
              GestureDetector(
                onTap: () => _showCommentsBottomSheet(context, index),
                child: Container(
                  color: Colors.transparent, // Expand hit area
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: _buildActionItem(
                    'assets/post/comment.svg',
                    '${post['comments']}',
                    const Color(0xFF495565),
                    size: 22, // Increased size
                  ),
                ),
              ),
              
              const Spacer(),

              // Speaker
              const Icon(
                Icons.volume_up_outlined,
                size: 20,
                color: Color(0xFF495565),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryTag(String category) {
    Color bgColor;
    // Define colors based on category
    switch (category) {
      case 'Question':
        bgColor = const Color(0xFFFF7F00); // Orange
        break;
      case 'Sell':
        bgColor = const Color(0xFF22C55E); // Green
        break;
      case 'Info':
        bgColor = const Color(0xFFA855F7); // Purple
        break;
        case 'Jobs':
        bgColor = Colors.blue;
        break;
        case 'Rentals':
        bgColor = Colors.teal;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _buildMoreOptionsButton() {
     return GestureDetector(
        onTap: () {
          Get.bottomSheet(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Save Post Option
                  InkWell(
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      // Add save logic here
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/post/saves.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Save post',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF354152),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Report Option
                  InkWell(
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      // Add report logic here
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/post/report.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Report',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFEF4444), // Red color for report
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Divider(color: Color(0xFFF3F4F6), thickness: 1),
                  const SizedBox(height: 24),
                  
                  // Edit Post Option
                  InkWell(
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      // Add edit logic here
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          size: 24,
                          color: Color(0xFF354152),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Edit Post',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF354152),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Completed Option
                  InkWell(
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      // Add completed logic here
                    },
                    child: Row(
                      children: [
                       const Icon(
                          Icons.check_circle_outline,
                          size: 24,
                          color: Color(0xFF00C853),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Completed',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF00C853), // Green for completed
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Delete Post Option
                  InkWell(
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      // Add delete logic here
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          size: 24,
                          color: Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Delete Post',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFEF4444), // Red used for delete action
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.more_vert, color: Color(0xFF697282), size: 20),
      );
  }

  Widget _buildActionItem(String iconPath, String count, Color color, {double size = 18}) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: size, 
          height: size,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        Text(
          count,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _showCommentsBottomSheet(BuildContext context, int index) {
    TextEditingController commentController = TextEditingController();
    
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.75, // Take up 75% of screen
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle for bottom sheet
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => Text(
                'Comments (${controller.posts[index]["comments"]})',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF101727),
                ),
              )),
            ),
            
            const Divider(height: 1),
            
            // Comments List
            Expanded(
              child: Obx(() {
                final comments = controller.posts[index]["commentsList"] as List<dynamic>? ?? [];
                
                if (comments.isEmpty) {
                  return Center(
                    child: Text(
                      'No comments yet. Be the first!',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  );
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, commentIndex) {
                    final comment = comments[commentIndex];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(comment['avatar']),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    comment['name'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    comment['time'],
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment['text'],
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF354152),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
            
            // Input Area
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                         if (commentController.text.isNotEmpty) {
                            controller.addComment(index, commentController.text);
                            commentController.clear();
                         }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF08080),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildPostImages(List<dynamic> images) {
    int count = images.length;
    if (count == 0) return const SizedBox.shrink();
    
    return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 300, // Fixed height for the grid
          child: _buildLayout(images, count),
        ),
    );
  }

  Widget _buildLayout(List<dynamic> images, int count) {
    if (count == 1) {
      return _buildImage(images[0]);
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(child: _buildImage(images[0])),
          const SizedBox(width: 4),
          Expanded(child: _buildImage(images[1])),
        ],
      );
    } else if (count == 3) {
      return Row(
        children: [
          Expanded(child: _buildImage(images[0])),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _buildImage(images[1])),
                const SizedBox(height: 4),
                Expanded(child: _buildImage(images[2])),
              ],
            ),
          ),
        ],
      );
    } else {
      // 4 or more
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                 Expanded(child: _buildImage(images[0])),
                 const SizedBox(width: 4),
                 Expanded(child: _buildImage(images[1])),
              ],
            ),
          ),
          const SizedBox(height: 4),
           Expanded(
            child: Row(
              children: [
                 Expanded(child: _buildImage(images[2])),
                 const SizedBox(width: 4),
                 Expanded(
                   child: count > 4 
                     ? Stack(
                         fit: StackFit.expand,
                         children: [
                           _buildImage(images[3]),
                           Container(
                             color: Colors.black54,
                             alignment: Alignment.center,
                             child: Text(
                               "+${count - 4}",
                               style: GoogleFonts.poppins(
                                 color: Colors.white,
                                 fontSize: 24,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           )
                         ],
                       )
                     : _buildImage(images[3]),
                 ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFDC143C)),
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }
}
