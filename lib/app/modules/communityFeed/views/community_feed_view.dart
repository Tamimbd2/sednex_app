import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/community_feed_controller.dart';

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
        color: const Color(0xFFDC143C),
        onRefresh: () => controller.refreshPosts(),
        child: Obx(() {
          if (controller.isLoading.value && controller.posts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC143C)),
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
                        child: _buildPostCard(context, index),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC143C)),
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
              _buildMoreOptionsButton(post, index),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Content with See more / See less
          Obx(() {
            final isExpanded = controller.expandedPosts.contains(index);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['content'],
                  maxLines: isExpanded ? null : 5,
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF354152),
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textSpan = TextSpan(
                      text: post['content'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                    final tp = TextPainter(
                      text: textSpan,
                      maxLines: 5,
                      textDirection: TextDirection.ltr,
                    );
                    tp.layout(maxWidth: constraints.maxWidth);
                    if (tp.didExceedMaxLines) {
                      return GestureDetector(
                        onTap: () => controller.toggleExpand(index),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            isExpanded ? 'See less' : 'See more',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF697282),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          }),
          
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
  Widget _buildMoreOptionsButton(Map<String, dynamic> post, int index) {
    bool isOwnPost = controller.userId != null && post['authorId'] == controller.userId;

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
                if (isOwnPost) ...[
                  // Edit Post
                  _buildOptionItem(
                    icon: Icons.edit_outlined,
                    label: 'Edit post',
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      _showEditPostDialog(post, index);
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Completed
                  _buildOptionItem(
                    icon: Icons.check_circle_outline,
                    label: 'Completed',
                    color: const Color(0xFF00C853),
                    onTap: () {
                      Get.back();
                      // Mark as completed logic
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Delete Post
                  _buildOptionItem(
                    icon: Icons.delete_outline,
                    label: 'Delete post',
                    color: const Color(0xFFEF4444),
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      _showDeleteConfirmation(index);
                    },
                  ),
                ] else ...[
                  // Save Post
                  _buildOptionItem(
                    label: 'Save post',
                    iconSrc: 'assets/post/saves.svg',
                    onTap: () {
                      Get.back(); // Close bottom sheet
                      controller.savePost(index);
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Report
                  _buildOptionItem(
                    label: 'Report',
                    iconSrc: 'assets/post/report.svg',
                    color: const Color(0xFFEF4444),
                    onTap: () {
                      Get.back();
                      // Report logic
                    },
                  ),
                ],
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

  void _showEditPostDialog(Map<String, dynamic> post, int index) {
    final TextEditingController editController = TextEditingController(text: post['content']);
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit Post',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: editController,
          maxLines: 5,
          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Enter post content...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDC143C)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: const Color(0xFF697282)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                Get.back();
                controller.updatePost(index, editController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC143C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Save Changes',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Post?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: const Color(0xFF697282)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deletePost(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String label,
    String? iconSrc,
    IconData? icon,
    required VoidCallback onTap,
    Color color = const Color(0xFF354152),
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (iconSrc != null)
            SvgPicture.asset(
              iconSrc,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            )
          else if (icon != null)
            Icon(icon, size: 24, color: color),
          
          const SizedBox(width: 16),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
    controller.fetchComments(index); // Trigger fetch when opened
    
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
                if (controller.isLoadingComments.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFDC143C),
                    ),
                  );
                }

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
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  controller.setReplyTarget(comment['_id'], comment['name']);
                                },
                                child: Text(
                                  'Reply',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF101727),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
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
            
            // Reply Target Indicator
            Obx(() {
              if (controller.replyTargetCommentId.value == null) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[100],
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Replying to ${controller.replyTargetName.value}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF697282),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.clearReplyTarget(),
                      child: const Icon(Icons.close, size: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }),

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
                        child: Obx(() => TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: controller.replyTargetCommentId.value != null 
                              ? 'Write a reply...' 
                              : 'Add a comment...',
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                        )),
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
    ).then((_) => controller.clearReplyTarget()); // Clear target on close
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
      return _buildImage(images[0], images, 0);
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(child: _buildImage(images[0], images, 0)),
          const SizedBox(width: 4),
          Expanded(child: _buildImage(images[1], images, 1)),
        ],
      );
    } else if (count == 3) {
      return Row(
        children: [
          Expanded(child: _buildImage(images[0], images, 0)),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _buildImage(images[1], images, 1)),
                const SizedBox(height: 4),
                Expanded(child: _buildImage(images[2], images, 2)),
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
                 Expanded(child: _buildImage(images[0], images, 0)),
                 const SizedBox(width: 4),
                 Expanded(child: _buildImage(images[1], images, 1)),
              ],
            ),
          ),
          const SizedBox(height: 4),
           Expanded(
            child: Row(
              children: [
                 Expanded(child: _buildImage(images[2], images, 2)),
                 const SizedBox(width: 4),
                 Expanded(
                   child: count > 4 
                     ? Stack(
                         fit: StackFit.expand,
                         children: [
                           _buildImage(images[3], images, 3),
                           GestureDetector(
                             onTap: () => _openFullScreenImage(images, 3),
                             child: Container(
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
                             ),
                           )
                         ],
                       )
                     : _buildImage(images[3], images, 3),
                 ),
              ],
            ),
          ),
        ],
      );
    }
  }

  void _openFullScreenImage(List<dynamic> images, int initialIndex) {
    Get.to(
      () => FullScreenImageViewer(images: images, initialIndex: initialIndex),
      opaque: false,
      fullscreenDialog: true,
    );
  }

  Widget _buildImage(String url, List<dynamic> allImages, int index) {
    return GestureDetector(
      onTap: () => _openFullScreenImage(allImages, index),
      child: Image.network(
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
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final List<dynamic> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: initialIndex);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background dismiss area
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(color: Colors.black),
          ),
          
          // Image PageView
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.network(
                    images[index],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDC143C)),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 50,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Header with back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
