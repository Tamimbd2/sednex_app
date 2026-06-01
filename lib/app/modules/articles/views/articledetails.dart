import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/modules/articles/controllers/articles_controller.dart';
import 'package:sednexapp/app/modules/savedArticles/controllers/saved_articles_controller.dart';
import '../../../core/theme/app_text_styles.dart';

class ArticleDetailsView extends StatelessWidget {
  const ArticleDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments is Map 
        ? Map<String, dynamic>.from(Get.arguments as Map) 
        : {};
    final String title = args['title'] ?? 'Article Title';
    final String description = args['description'] ?? '';
    final String category = args['category'] ?? 'General';
    final DateTime date = args['date'] ?? DateTime.now();
    final List<dynamic> fullContent = args['fullContent'] ?? [];
    
    // Find available controller to handle saving (either ArticlesController or SavedArticlesController)
    dynamic controller;
    if (Get.isRegistered<ArticlesController>()) {
      controller = Get.find<ArticlesController>();
    } else if (Get.isRegistered<SavedArticlesController>()) {
      controller = Get.find<SavedArticlesController>();
    }

    final articleId = args['id'] ?? '';
    
    // Find the article in whichever controller we have
    Article? article;
    if (controller != null) {
      final List<Article> articleList = controller.articles;
      article = articleList.firstWhereOrNull((a) => a.id == articleId);
    }
    
    // If not found in controller, create a temporary one from args for viewing
    article ??= Article(
      id: articleId,
      title: title,
      description: description,
      imageUrl: args['imageUrl'] ?? '',
      date: date,
      fullContent: fullContent,
      category: category,
      isSaved: true, // If we came from SavedArticlesView, it's likely saved
    );

    final String formattedDate = _formatDate(date);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Article Details',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // Premium Header: Category and Actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x141E63FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF1E63FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),

              if (controller != null) ...[
                const SizedBox(width: 8),
                Obx(() {
                  final isSaved = article!.isSaved.value;
                  return GestureDetector(
                    onTap: () => controller.toggleSaved(article!),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSaved ? const Color(0xFF1E63FF) : Colors.grey[50],
                        border: Border.all(color: isSaved ? Colors.transparent : Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        size: 20,
                        color: isSaved ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Date Row
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 6),
              Text(
                formattedDate,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            _parseHtml(title),
            style: AppTextStyles.headingLarge.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1.2, color: Color(0xFFF1F1F1)),
          const SizedBox(height: 16),

          // Content Rendering
          if (fullContent.isEmpty)
            _buildHtmlWidget(description)
          else
            ..._groupContent(fullContent),

          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}

  // Optimized logic to group contiguous paragraphs into single Html widgets
  // and efficiently render images to prevent ANR.
  List<Widget> _groupContent(List<dynamic> content) {
    List<Widget> widgets = [];
    String currentParagraphs = "";

    for (var item in content) {
      if (item is! Map) continue;

      if (item['type'] == 'paragraph') {
        // Strip out carriage returns and trailing/leading blank lines that cause gaps
        String data = (item['data'] ?? '').toString()
            .replaceAll('\r', '')
            .replaceAll(RegExp(r'\n{2,}'), '\n') // Remove double vertical spaces
            .trim();
        if (data.isNotEmpty) {
          currentParagraphs += "<p>$data</p>";
        }
      } else {
        // If we hit an image, flush current paragraphs first
        if (currentParagraphs.isNotEmpty) {
          widgets.add(_buildHtmlWidget(currentParagraphs));
          currentParagraphs = "";
        }

        if (item['type'] == 'image') {
          final imageUrl = item['url'] ?? '';
          if (imageUrl.isNotEmpty) {
            widgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    memCacheHeight:
                        400, // Optimized: don't load huge resolution into memory
                    placeholder: (context, url) => Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const SizedBox.shrink(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            );
          }
        }
      }
    }

    // Flush any remaining paragraphs
    if (currentParagraphs.isNotEmpty) {
      widgets.add(_buildHtmlWidget(currentParagraphs));
    }

    return widgets;
  }

  Widget _buildHtmlWidget(String data) {
    // Optimized: Sanitize data to remove any 'font-feature-settings' which can cause an assertion crash 
    // in flutter_html 3.0.0 if the tag is not exactly 4 characters (e.g. empty or invalid).
    String sanitizedData = data.replaceAll(
      RegExp(r'font-feature-settings\s*:\s*[^;"]+;?'), 
      '',
    );

    return Html(
      data: sanitizedData,
      style: {
        "body": Style(
          fontSize: FontSize(15),
          lineHeight: const LineHeight(1.5),
          color: const Color(0xFF2C2C2C),
          fontFamily: AppTextStyles.bengaliFontFamily, // Render using Noto Sans Bengali
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        "p": Style(
          margin: Margins.only(bottom: 8), // Standard space between paragraphs
          padding: HtmlPaddings.zero,
          fontSize: FontSize(15),
          lineHeight: const LineHeight(1.5),
        ),
        "h1,h2,h3": Style(
          fontSize: FontSize(16),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF111111),
          margin: Margins.only(top: 16, bottom: 6),
          padding: HtmlPaddings.zero,
          fontFamily: AppTextStyles.bengaliFontFamily,
        ),
        "ul,ol": Style(
          margin: Margins.only(top: 4, bottom: 8),
          padding: HtmlPaddings.only(left: 14), // Proper bullet indent
        ),
        "li": Style(
          margin: Margins.only(bottom: 6), // Clean spacing between list elements
          lineHeight: const LineHeight(1.45),
          fontSize: FontSize(15),
        )
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
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
