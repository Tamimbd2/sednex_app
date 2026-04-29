import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/saved_articles_controller.dart';
import '../../articles/controllers/articles_controller.dart';
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
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
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
                  Icons.newspaper,
                  size: 64,
                  color: Colors.grey[300],
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
            separatorBuilder: (context, index) => const SizedBox(height: 16),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to details if needed
          // Get.toNamed(Routes.ARTICLE_DETAILS, arguments: article);
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: article.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[100],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E63FF).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          article.category,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E63FF),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark,
                          color: Color(0xFF1E63FF),
                        ),
                        onPressed: () => controller.toggleSaved(article),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF101727),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF697282),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
