import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:shimmer/shimmer.dart';
import 'package:sednexapp/app/core/theme/app_colors.dart';
import 'package:sednexapp/app/core/theme/app_text_styles.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'notifications_title'.tr,
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E63FF),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            if (controller.unreadCount > 0) {
              return TextButton(
                onPressed: () => controller.markAllAsRead(),
                child: Text(
                  'mark_all_read'.tr,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return _buildLoadingSkeleton();
        }

        if (controller.error.value != null && controller.notifications.isEmpty) {
          return _buildMinimalState(
            icon: Icons.error_outline_rounded,
            title: 'connection_issue'.tr,
            subtitle: controller.error.value!,
          );
        }

        if (controller.notifications.isEmpty) {
          return _buildMinimalState(
            icon: Icons.notifications_none_rounded,
            title: 'all_caught_up'.tr,
            subtitle: 'no_new_notifications'.tr,
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(),
          color: AppColors.primary,
          edgeOffset: 20,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              
              // Simple grouping logic (e.g. show date header if first or date changed)
              bool showHeader = false;
              if (index == 0) {
                showHeader = true;
              } else {
                final prev = controller.notifications[index - 1];
                if (!_isSameDay(prev.createdAt, notification.createdAt)) {
                  showHeader = true;
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader) _buildDateHeader(notification.createdAt),
                  _buildSmoothNotificationCard(notification, index),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        _getFormattedDateHeader(date).toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.text.withValues(alpha: 0.4),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSmoothNotificationCard(NotificationModel notification, int index) {

    
    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          controller.markAsRead(notification.id);
        }
        
        switch (notification.type.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_')) {
          case 'article':
            Get.toNamed('/articles');
            break;
          case 'post':
          case 'community_feed':
          case 'community':
            Get.toNamed('/community-feed');
            break;
          case 'local_tour':
          case 'localtour':
          case 'tour':
            Get.toNamed('/localtour');
            break;
          default:
            // Handle other or general types
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withAlpha(15), 
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconBadge(notification),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mainText.withValues(alpha: 0.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getRelativeTime(notification.createdAt),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.message,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 13,
                      color: AppColors.text.withValues(alpha: 0.6),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBadge(NotificationModel notification) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _getIconColor(notification.type).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getIcon(notification.type),
        color: _getIconColor(notification.type),
        size: 18,
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150, height: 12, color: Colors.white),
                    const SizedBox(height: 10),
                    Container(width: double.infinity, height: 10, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(width: 200, height: 10, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalState({required IconData icon, required String title, required String subtitle}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.04), shape: BoxShape.circle),
              child: Icon(icon, size: 48, color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.headingSmall.copyWith(fontSize: 17, color: AppColors.mainText),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 13, color: AppColors.text.withValues(alpha: 0.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getFormattedDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return 'today'.tr;
    if (checkDate == yesterday) return 'yesterday'.tr;
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  String _getRelativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just_now'.tr;
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'article': return Icons.article_outlined;
      case 'order': return Icons.local_mall_outlined;
      case 'promo': return Icons.confirmation_number_outlined;
      default: return Icons.notifications_none_rounded;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'article': return const Color(0xFF6366F1);
      case 'order': return const Color(0xFF10B981);
      case 'promo': return const Color(0xFFF59E0B);
      default: return AppColors.primary;
    }
  }

}
