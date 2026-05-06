import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../community/views/communityprofiledetails.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CommunityPostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final int index;
  final dynamic
  controller; // Changed to dynamic for reuse with MypostController
  final bool isDashboard;
  final bool showFooter;

  const CommunityPostCard({
    super.key,
    required this.post,
    required this.index,
    required this.controller,
    this.isDashboard = false,
    this.showFooter = true,
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final authorData =
                        post['author'] ??
                        {
                          '_id': post['authorId'],
                          'name': post['name'],
                          'profileImage': post['avatar'],
                        };
                    Get.to(
                      () => CommunityProfileDetailsView(member: authorData),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: CachedNetworkImageProvider(
                          post['avatar'] ?? '',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['name'] ?? 'User',
                              style: AppTextStyles.bodyMedium.copyWith(
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
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: const Color(0xFF697282),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                if (post['category'] != null) ...[
                                  const SizedBox(width: 8),
                                  _buildCategoryTag(post['category']),
                                ],
                                if (post['isCompleted'] == true) ...[
                                  const SizedBox(width: 8),
                                  _buildCompletedBadge(),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                  maxLines: isExpanded || isDashboard
                      ? (isDashboard ? 3 : null)
                      : 5,
                  overflow: isExpanded || isDashboard
                      ? (isDashboard
                            ? TextOverflow.ellipsis
                            : TextOverflow.visible)
                      : TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
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
                        style: AppTextStyles.bodyMedium.copyWith(
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
                              style: AppTextStyles.bodyMedium.copyWith(
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

          if (showFooter) ...[
            const SizedBox(height: 4),
            // Footer
            Row(
              children: [
                // Like
                GestureDetector(
                  onTap: () => controller.toggleLike(index),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 24,
                          color: post['isLiked'] ?? false
                              ? const Color(0xFF1E63FF)
                              : Colors.grey[400],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${post['likes'] ?? 0}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: post['isLiked'] ?? false
                                ? const Color(0xFF1E63FF)
                                : Colors.grey[600],
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/post/comment.svg',
                          width: 22,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF495565),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${post['comments'] ?? 0}',
                          style: AppTextStyles.bodyMedium.copyWith(
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
                Obx(() {
                  final isSpeaking =
                      controller.currentlySpeakingIndex.value == index;
                  return IconButton(
                    onPressed: () =>
                        controller.speakPost(index, post['content'] ?? ''),
                    icon: Icon(
                      isSpeaking
                          ? Icons.stop_circle_rounded
                          : Icons.volume_up_outlined,
                      size: 24,
                      color: isSpeaking
                          ? const Color(0xFF1E63FF)
                          : const Color(0xFF495565),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  );
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryTag(String category) {
    Color bgColor;
    switch (category) {
      case 'Questions':
        bgColor = const Color(0xFFFF7F00);
        break;
      case 'Buy & Sells':
        bgColor = const Color(0xFF22C55E);
        break;
      case 'Info':
        bgColor = const Color(0xFFA855F7);
        break;
      case 'Job Posts':
        bgColor = Colors.blue;
        break;
      case 'Home Rents':
        bgColor = Colors.teal;
        break;
      case 'Help Request':
        bgColor = const Color(0xFFF43F5E);
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
        style: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMoreOptionsButton(BuildContext context) {
    bool isOwnPost =
        controller.userId != null && post['authorId'] == controller.userId;

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
                      label: 'edit_post'.tr,
                      onTap: () {
                        Get.back();
                        _showEditPostDialog();
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildOptionItem(
                      icon: (post['isCompleted'] ?? false)
                          ? Icons.lock_open_outlined
                          : Icons.check_circle_outline,
                      label: (post['isCompleted'] ?? false)
                          ? 'open_post'.tr
                          : _getCategoryActionLabel(),
                      color: const Color(0xFF00C853),
                      onTap: () {
                        Get.back();
                        controller.markAsCompleted(index);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildOptionItem(
                      icon: Icons.delete_outline,
                      label: 'delete_post'.tr,
                      color: const Color(0xFFEF4444),
                      onTap: () {
                        Get.back();
                        _showDeleteConfirmation();
                      },
                    ),
                  ] else ...[
                    _buildOptionItem(
                      label:
                          controller.runtimeType.toString() ==
                                  'SavepostController'
                              ? 'unsave_post'.tr
                              : 'save_post'.tr,
                      iconSrc: 'assets/post/saves.svg',
                      onTap: () {
                        Get.back();
                        controller.savePost(index);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildOptionItem(
                      label: 'report'.tr,
                      iconSrc: 'assets/post/report.svg',
                      color: const Color(0xFFEF4444),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ],
                ],
              ),
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
            style: AppTextStyles.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPostDialog() {
    final TextEditingController editController = TextEditingController(
      text: post['content'],
    );
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'edit_post'.tr,
          style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: editController,
          maxLines: 5,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'add_comment'.tr,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
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
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'save'.tr,
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'delete_confirmation_title'.tr,
          style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'delete_confirmation_msg'.tr,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
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
              'delete'.tr,
              style: AppTextStyles.button.copyWith(color: Colors.white),
            ),
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
        height:
            MediaQuery.of(context).size.height * 0.75, // Take up 75% of screen
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
              child: Obx(
                () => Text(
                  'Comments (${controller.posts[index]["comments"]})',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101727),
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // Comments List
            Expanded(
              child: Obx(() {
                if (controller.isLoadingComments.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
                  );
                }

                final comments =
                    controller.posts[index]["commentsList"] as List<dynamic>? ??
                    [];

                if (comments.isEmpty) {
                  return Center(
                    child: Text(
                      'No comments yet. Be the first!',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, commentIndex) {
                    final comment = comments[commentIndex];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: CachedNetworkImageProvider(
                            comment['avatar'],
                          ),
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
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    comment['time'],
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment['text'],
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: const Color(0xFF354152),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.setReplyTarget(
                                        comment['_id'],
                                        comment['name'],
                                      );
                                    },
                                    child: Text(
                                      'Reply',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: const Color(0xFF101727),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Obx(() {
                                    if (comment['replies'].isEmpty &&
                                        !comment['isRepliesLoading'].value) {
                                      return GestureDetector(
                                        onTap: () => controller.fetchReplies(
                                          index,
                                          commentIndex,
                                        ),
                                        child: Text(
                                          'View Replies',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: const Color(0xFF697282),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),
                                ],
                              ),
                              // Replies Section
                              Obx(() {
                                if (comment['isRepliesLoading'].value) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }

                                if (comment['replies'].isNotEmpty) {
                                  return Column(
                                    children: [
                                      if (!comment['showReplies'].value)
                                        GestureDetector(
                                          onTap: () =>
                                              comment['showReplies'].value =
                                                  true,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Text(
                                              'Show ${comment['replies'].length} replies',
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                color: AppColors.primary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        )
                                      else ...[
                                        const SizedBox(height: 12),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: comment['replies'].length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 12),
                                          itemBuilder: (context, rIndex) {
                                            final reply =
                                                comment['replies'][rIndex];
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                        reply['avatar'],
                                                      ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            reply['name'],
                                                            style:
                                                                AppTextStyles.bodyMedium.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 13,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            reply['time'],
                                                            style:
                                                                AppTextStyles.bodyMedium.copyWith(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 11,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        reply['text'],
                                                        style:
                                                            AppTextStyles.bodyMedium.copyWith(
                                                              color:
                                                                  const Color(
                                                                    0xFF354152,
                                                                  ),
                                                              fontSize: 13,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              comment['showReplies'].value =
                                                  false,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 12.0,
                                            ),
                                            child: Text(
                                              'Hide replies',
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                color: const Color(0xFF697282),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
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
              if (controller.replyTargetCommentId.value == null) {
                return const SizedBox.shrink();
              }
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.grey[100],
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Replying to ${controller.replyTargetName.value}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: const Color(0xFF697282),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.clearReplyTarget(),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey,
                      ),
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
                        child: Obx(
                          () => TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText:
                                  controller.replyTargetCommentId.value != null
                                  ? 'Write a reply...'
                                  : 'Add a comment...',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
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
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
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
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
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
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E63FF)),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }

  String _getCategoryStatusLabel() {
    String category = post['category'] ?? 'general';
    switch (category.toLowerCase()) {
      case 'jobs':
        return 'filled'.tr;
      case 'sell':
      case 'buy & sell':
      case 'buy_sell':
        return 'sold'.tr;
      case 'question':
      case 'questions':
        return 'answered'.tr;
      case 'rental':
      case 'rentals':
        return 'rented'.tr;
      case 'help':
        return 'resolved'.tr;
      default:
        return 'closed'.tr;
    }
  }

  String _getCategoryActionLabel() {
    String category = post['category'] ?? 'general';
    switch (category.toLowerCase()) {
      case 'jobs':
        return 'mark_as_filled'.tr;
      case 'sell':
      case 'buy & sell':
      case 'buy_sell':
        return 'mark_as_sold'.tr;
      case 'question':
      case 'questions':
        return 'mark_as_answered'.tr;
      case 'rental':
      case 'rentals':
        return 'mark_as_rented'.tr;
      case 'help':
        return 'mark_as_resolved'.tr;
      default:
        return 'close_post'.tr;
    }
  }

  Widget _buildCompletedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF22C55E), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 10, color: Color(0xFF166534)),
          const SizedBox(width: 4),
          Text(
            _getCategoryStatusLabel(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF166534),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
    final PageController pageController = PageController(
      initialPage: initialIndex,
    );

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
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF1E63FF),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
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
                      color: Colors.black.withValues(alpha: 0.5),
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
