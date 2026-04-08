import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/articles_controller.dart';
import 'articledetails.dart';

class SavedArticlesView extends GetView<ArticlesController> {
  const SavedArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Saved Articles',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingSaved.value && controller.savedArticles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E63FF)),
            ),
          );
        }

        if (controller.savedArticles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_outline, size: 64, color: Colors.grey[200]),
                const SizedBox(height: 16),
                Text(
                  'No saved articles found',
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

        return RefreshIndicator(
          onRefresh: () => controller.fetchSavedArticles(),
          color: const Color(0xFF1E63FF),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.savedArticles.length,
            itemBuilder: (context, index) {
              final article = controller.savedArticles[index];
              return _buildSavedArticleCard(article);
            },
          ),
        );
      }),
    );
  }

  Widget _buildSavedArticleCard(Article article) {
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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: [
            // Thumbnail
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[100],
                    child: const Icon(Icons.image_not_supported_outlined, size: 24, color: Colors.grey),
                  ),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.article_outlined, color: Colors.grey),
              ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.category,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1E63FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.title,
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Unsave Action
            IconButton(
              onPressed: () => controller.toggleSaved(article),
              icon: const Icon(Icons.bookmark, color: Color(0xFF1E63FF), size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
