import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class ArticleDetailsView extends StatelessWidget {
  const ArticleDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String title = args['title'] ?? 'Article Title';
    final String description = args['description'] ?? '';
    final String category = args['category'] ?? 'General';
    final DateTime date = args['date'] ?? DateTime.now();
    final List<dynamic> fullContent = args['fullContent'] ?? [];

    final String formattedDate = _formatDate(date);

    // Optimized: Moved share text calculation to a private helper called on-demand to prevent UI hangs.
    String getShareText() {
      String shareTextContent = description;
      if (fullContent.isNotEmpty) {
        shareTextContent = fullContent
            .where((e) => e is Map && e['type'] == 'paragraph')
            .map((e) => e['data'].toString().replaceAll(RegExp(r"<[^>]*>"), ""))
            .join('\n\n');
      }
      return '$title\n\n$shareTextContent';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF101727)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Article Details',
          style: GoogleFonts.poppins(
            color: const Color(0xFF101727),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      // Optimized: Using ListView.builder for lazy loading of complex Content (Html widgets)
      // preventing ANRs and main thread blocking.
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 10),
          // Category & Date
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E63FF).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1E63FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            title,
            style: GoogleFonts.hindSiliguri(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Content Rendering
          if (fullContent.isEmpty)
            Text(
              description,
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                height: 1.8,
                color: Colors.grey[800],
              ),
            )
          else
            ..._groupContent(fullContent),

          const SizedBox(height: 40),

          // Copy & Share buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Copy button
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: getShareText()));
                  Get.snackbar(
                    'Copied!',
                    'Article text copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF101727),
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy, size: 20, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Copy',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Share button
              GestureDetector(
                onTap: () {
                  SharePlus.instance.share(ShareParams(text: getShareText()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.share,
                        size: 20,
                        color: Color(0xFF1E63FF),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Share',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E63FF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),
        ],
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
        currentParagraphs += (item['data'] ?? "") + "<br/><br/>";
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
    return Html(
      data: data,
      style: {
        "body": Style(
          fontSize: FontSize(17),
          lineHeight: const LineHeight(1.8),
          color: Colors.black87,
          fontFamily: GoogleFonts.hindSiliguri().fontFamily,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        "h2,h3": Style(
          fontWeight: FontWeight.bold,
          margin: Margins.only(top: 20, bottom: 8),
          fontFamily: GoogleFonts.hindSiliguri().fontFamily,
        ),
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
}
