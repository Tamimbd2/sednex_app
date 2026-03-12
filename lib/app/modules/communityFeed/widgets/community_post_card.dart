import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/community_feed_controller.dart';

class CommunityPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final int index;
  final CommunityFeedController controller;
  final bool isDashboard; // Added to handle dashboard specific UI if needed

  const CommunityPostCard({
    super.key,
    required this.post,
    required this.index,
    required this.controller,
    this.isDashboard = false,
  });

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(post['avatar'] ?? ''),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['name'] ?? 'User',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF101727),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          post['time'] ?? '',
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
              _buildMoreOptionsButton(context),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Content
          Obx(() {
            final isExpanded = controller.expandedPosts.contains(index);
            final content = post['content'] ?? '';
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  maxLines: isExpanded || isDashboard ? (isDashboard ? 3 : null) : 5,
                  overflow: isExpanded || isDashboard ? (isDashboard ? TextOverflow.ellipsis : TextOverflow.visible) : TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF354152),
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (!isDashboard)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final textSpan = TextSpan(
                        text: content,
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
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 24,
                        color: post['isLiked'] ?? false ? const Color(0xFFDC143C) : Colors.grey[400], 
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post['likes'] ?? 0}',
                        style: GoogleFonts.poppins(
                          color: post['isLiked'] ?? false ? const Color(0xFFDC143C) : Colors.grey[600],
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
                onTap: () => _showCommentsBottomSheet(context),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/post/comment.svg',
                        width: 22, 
                        height: 22,
                        colorFilter: const ColorFilter.mode(Color(0xFF495565), BlendMode.srcIn),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post['comments'] ?? 0}',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF495565),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
    switch (category) {
      case 'Question':
        bgColor = const Color(0xFFFF7F00);
        break;
      case 'Sell':
        bgColor = const Color(0xFF22C55E);
        break;
      case 'Info':
        bgColor = const Color(0xFFA855F7);
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

  Widget _buildMoreOptionsButton(BuildContext context) {
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
                  _buildOptionItem(
                    icon: Icons.edit_outlined,
                    label: 'Edit post',
                    onTap: () {
                      Get.back();
                      _showEditPostDialog();
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildOptionItem(
                    icon: Icons.check_circle_outline,
                    label: 'Completed',
                    color: const Color(0xFF00C853),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildOptionItem(
                    icon: Icons.delete_outline,
                    label: 'Delete post',
                    color: const Color(0xFFEF4444),
                    onTap: () {
                      Get.back();
                      _showDeleteConfirmation();
                    },
                  ),
                ] else ...[
                  _buildOptionItem(
                    label: 'Save post',
                    iconSrc: 'assets/post/saves.svg',
                    onTap: () {
                      Get.back();
                      controller.savePost(index);
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildOptionItem(
                    label: 'Report',
                    iconSrc: 'assets/post/report.svg',
                    color: const Color(0xFFEF4444),
                    onTap: () {
                      Get.back();
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

  void _showEditPostDialog() {
    final TextEditingController editController = TextEditingController(text: post['content']);
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Post', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: editController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter post content...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                Get.back();
                controller.updatePost(index, editController.text.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Post?'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deletePost(index);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: isDashboard ? 200 : 300,
        width: double.infinity,
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
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(color: Colors.black),
          ),
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
