import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/saved_articles_controller.dart';
import '../../articles/controllers/articles_controller.dart';
import '../../articles/views/articledetails.dart';
import '../../../core/theme/app_text_styles.dart';

class SavedArticlesView extends GetView<SavedArticlesController> {
  const SavedArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'saved_articles'.tr,
          style: AppTextStyles.appBarTitle,
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF1E63FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
          );
        }

        if (controller.articles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_outline,
                  size: 64,
                  color: Colors.grey[200],
                ),
                const SizedBox(height: 16),
                Text(
                  'no_saved_articles'.tr,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF1E63FF),
          onRefresh: () => controller.fetchSavedArticles(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.articles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 0), // ArticlesView uses margin in card
            itemBuilder: (context, index) {
              final article = controller.articles[index];
              return _buildArticleCard(context, article);
            },
          ),
        );
      }),
    );
  }

  Widget _buildArticleCard(BuildContext context, Article article) {
    bool isNetworkImage = article.imageUrl.startsWith('http');

    return GestureDetector(
      onTap: () {
        Get.to(
          () => const ArticleDetailsView(),
          arguments: {
            'id': article.id,
            'title': article.title,
            'description': article.description,
            'imageUrl': article.imageUrl,
            'date': article.date,
            'fullContent': article.fullContent,
            'category': article.category,
            'authorName': article.authorName,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image - Only show if not empty
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: isNetworkImage
                      ? CachedNetworkImage(
                          imageUrl: article.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[50],
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey[300],
                              size: 40,
                            ),
                          ),
                        )
                      : Image.asset(article.imageUrl, fit: BoxFit.cover),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metadata Row: Category & Time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E63FF).withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          article.category,
                          style: AppTextStyles.label.copyWith(
                            color: const Color(0xFF1E63FF),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.circle, size: 4, color: Colors.grey[300]),
                      const SizedBox(width: 8),
                      Text(
                        _smartDate(article.date),
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    _parseHtml(article.title),
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    _parseHtml(article.description),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),

                  // Actions Row: Read More and Save
                  Row(
                    children: [
                      // Read More Button
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => const ArticleDetailsView(),
                            arguments: {
                              'id': article.id,
                              'title': article.title,
                              'description': article.description,
                              'imageUrl': article.imageUrl,
                              'date': article.date,
                              'fullContent': article.fullContent,
                              'category': article.category,
                              'authorName': article.authorName,
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E63FF).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'read_more'.tr,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: const Color(0xFF1E63FF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: Color(0xFF1E63FF),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Save Button (Toggle)
                      Obx(() {
                        final isSaved = article.isSaved.value;
                        return GestureDetector(
                          onTap: () => controller.toggleSaved(article),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSaved ? const Color(0xFF1E63FF) : Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSaved ? Colors.transparent : Colors.grey[200]!,
                              ),
                            ),
                            child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              size: 18,
                              color: isSaved ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _smartDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final articleDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(articleDay).inDays;

    if (diff == 0) return 'today'.tr;
    if (diff == 1) return 'yesterday'.tr;

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String _parseHtml(String htmlString) {
    if (htmlString.isEmpty) return "";
    return htmlString
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }
}
