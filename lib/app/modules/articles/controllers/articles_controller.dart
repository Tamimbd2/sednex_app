import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class Article {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final List<dynamic> fullContent;
  final String category;
  final String? authorName;
  var isSaved = false.obs;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.fullContent,
    required this.category,
    this.authorName,
    bool isSaved = false,
  }) {
    this.isSaved.value = isSaved;
  }
}

class ArticlesController extends GetxController {
  final categories = <String>['All'].obs;
  final categoriesMap = <String, String>{}.obs; // ID -> Name map
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;
  final articles = <Article>[].obs;
  final isLoading = true.obs;

  final selectedFilterCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void search(String query) {
    searchQuery.value = query;
  }

  Future<void> _initializeData() async {
    isLoading.value = true;
    await fetchCategories();
    await fetchArticles();
    isLoading.value = false;
  }

  String _stripHtmlTags(String htmlString) {
    if (htmlString.isEmpty) return "";
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  Future<void> fetchCategories() async {
    try {
      final connect = GetConnect();
      final response = await connect.get('${AppUrl.baseUrl}api/article/category');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map && body['categories'] is List) {
          final List rawCats = body['categories'];
          final Map<String, String> newMap = {};
          
          for (var cat in rawCats) {
            final id = cat['_id']?.toString();
            final name = cat['name']?.toString();
            if (id != null && name != null) {
              newMap[id] = name;
            }
          }
          categoriesMap.assignAll(newMap);
          debugPrint('Categories mapped: ${categoriesMap.length} categories found.');
        }
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  Future<void> fetchArticles() async {
    if (!isLoading.value) isLoading.value = true;
    try {
      final connect = GetConnect();
      final response = await connect.get('${AppUrl.baseUrl}api/article/');

      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            debugPrint('Articles JSON error: $e');
            return;
          }
        }

        if (body is Map && body['articles'] is List) {
          final List rawArticles = body['articles'];

          // Map API data to Article objects
          final List<Article> mappedArticles = rawArticles.map<Article>((item) {
            final author = item['author'];
            final createdAt = item['createdAt'] ?? '';
            final List contentList = item['content'] is List ? item['content'] : [];
            
            DateTime parsedDate;
            try {
              parsedDate = DateTime.parse(createdAt).toLocal();
            } catch (_) {
              parsedDate = DateTime.now();
            }
            
            // Resolve Category Name from ID
            String catValue = item['category']?.toString() ?? '';
            String catName = 'General';
            
            if (categoriesMap.containsKey(catValue)) {
              catName = categoriesMap[catValue]!;
            } else if (item['category'] is Map) {
              catName = item['category']['name'] ?? 'General';
            } else if (catValue.isNotEmpty && !catValue.contains(RegExp(r'^[0-9a-fA-F]{24}$'))) {
              // If it's already a name (not a 24-char hex ID), use it
              catName = catValue;
            }

            // Extract first image URL and first paragraph for preview
            String extractedImageUrl = '';
            String extractedDescription = '';

            for (var content in contentList) {
              if (content['type'] == 'image' && extractedImageUrl.isEmpty) {
                extractedImageUrl = content['url'] ?? '';
              }
              if (content['type'] == 'paragraph' && extractedDescription.isEmpty) {
                extractedDescription = _stripHtmlTags(content['data'] ?? '');
              }
            }

            return Article(
              id: item['_id'] ?? '',
              title: item['title'] ?? 'Untitled',
              description: extractedDescription.isNotEmpty 
                  ? extractedDescription 
                  : (item['description'] ?? ''),
              imageUrl: extractedImageUrl,
              date: parsedDate,
              fullContent: contentList,
              category: catName,
              authorName: author != null ? author['name'] : null,
            );
          }).toList();

          // Sort articles by date descending (recent first)
          mappedArticles.sort((a, b) => b.date.compareTo(a.date));

          articles.assignAll(mappedArticles);

          // Extract unique categories from API data (now with names) and build chips
          final Set<String> uniqueCategoryNames = {};
          for (var article in mappedArticles) {
            if (article.category.isNotEmpty) {
              uniqueCategoryNames.add(article.category);
            }
          }

          // Build categories list: "All" + unique category names
          categories.assignAll(['All', ...uniqueCategoryNames.toList()..sort()]);

          debugPrint('Articles loaded with category names: ${mappedArticles.length}');
        }
      }
    } catch (e) {
      debugPrint("Error fetching articles: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshArticles() async {
    await fetchArticles();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    // Clear filter mode when selecting a chip
    selectedFilterCategories.clear();
  }

  void toggleFilterCategory(String category) {
    if (selectedFilterCategories.contains(category)) {
      selectedFilterCategories.remove(category);
    } else {
      selectedFilterCategories.add(category);
    }
  }

  void selectAllFilters() {
    selectedFilterCategories.assignAll(categories.where((c) => c != 'All'));
  }

  void clearAllFilters() {
    selectedFilterCategories.clear();
  }

  void applyFilters() {
    if (selectedFilterCategories.isEmpty) {
      selectedCategory.value = 'All';
    }
    Get.back();
  }

  void toggleSaved(Article article) {
    article.isSaved.value = !article.isSaved.value;
  }
}

