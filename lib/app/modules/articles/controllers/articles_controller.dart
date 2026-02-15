import 'package:get/get.dart';

class Article {
  final String title;
  final String description;
  final String imageUrl; // Keeping this if needed for details, though list view doesn't show it in the new design
  final DateTime date;
  final String content;
  final String category;
  var isSaved = false.obs;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.content,
    required this.category,
    bool isSaved = false,
  }) {
    this.isSaved.value = isSaved;
  }
}

class ArticlesController extends GetxController {
  final categories = [
    'All',
    'Immigration',
    'Visa Issues',
    'Family Law',
    'Employment',
    'Citizenship',
    'Housing',
    'Legal Documents'
  ];

  final selectedCategory = 'All'.obs;

  final List<Article> articles = [
    Article(
      category: 'Immigration',
      title: 'Work Permit Extension Process',
      description: 'What documents are required for extending a work permit in the USA? I need to renew mine in the next 2 months and want to make sure I have everything ready.',
      imageUrl: 'assets/essentialService/article.png',
      date: DateTime(2023, 10, 15),
      content: 'Detailed content about work permit extension...',
    ),
    Article(
      category: 'Visa Issues',
      title: 'Student Visa to Work Visa Conversion',
      description: 'Can I convert my F-1 student visa to an H-1B work visa while staying in the country? What are the steps and timeline involved?',
      imageUrl: 'assets/essentialService/article.png',
      date: DateTime(2023, 11, 20),
      content: 'Detailed content about visa conversion...',
      isSaved: true,
    ),
    Article(
      category: 'Family Law',
      title: 'Sponsoring Family Members',
      description: 'I\'m a permanent resident and want to sponsor my parents. What is the current processing time and what documents do I need to prepare?',
      imageUrl: 'assets/essentialService/article.png',
      date: DateTime(2023, 12, 05),
      content: 'Detailed content about sponsoring family...',
    ),
    Article(
      category: 'Employment',
      title: 'Workplace Rights for Immigrants',
      description: 'What are my rights as an immigrant worker? My employer is threatening to report me to immigration if I complain about unpaid overtime.',
      imageUrl: 'assets/essentialService/article.png',
      date: DateTime(2024, 01, 10),
      content: 'Detailed content about workplace rights...',
      isSaved: true,
    ),
    Article(
      category: 'Citizenship',
      title: 'Naturalization Application Timeline',
      description: 'I\'ve been a green card holder for 5 years. How long does the naturalization process typically take, and what are the interview questions like?',
      imageUrl: 'assets/essentialService/article.png',
      date: DateTime(2024, 02, 12),
      content: 'Detailed content about naturalization...',
    ),
    Article(
      category: 'Immigration',
      title: 'Travel Restrictions and Re-entry',
      description: 'I have a pending green card application. Can I travel outside the US and return safely? What documents should I carry?',
      imageUrl: 'assets/essentialService/article.png',
      date: DateTime(2024, 03, 15),
      content: 'Detailed content about travel restrictions...',
    ),
    Article(
      category: 'Legal Documents',
      title: 'Apostille Services for Bangladesh Documents',
      description: 'Where can I get my Bangladeshi birth certificate and educational documents apostilled for US immigration purposes?',
      imageUrl: 'assets/essentialService/article.png',
      date: DateTime(2024, 04, 20),
      content: 'Detailed content about apostille services...',
      isSaved: true,
    ),
    Article(
      category: 'Housing',
      title: 'Tenant Rights Without SSN',
      description: 'Can I rent an apartment without a Social Security Number? What alternative documents do landlords accept?',
      imageUrl: 'assets/essentialService/article.png',
      date: DateTime(2024, 05, 01),
      content: 'Detailed content about tenant rights...',
    ),
  ];

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  final selectedFilterCategories = <String>[].obs;

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
    // If filters are applied, loop through articles and show only those matching selected categories
    // If no categories selected, show all (or handle as 'All')
    // For this example, if the user clicks Apply, we can just update the main view to show articles from ANY of the selected categories
    // If list is empty, maybe revert to 'All' or show nothing. 
    // Let's assume 'All' logic if empty, otherwise filter by list.
    if (selectedFilterCategories.isEmpty) {
      selectedCategory.value = 'All';
    } else {
      // This is a bit tricky since previous logic used single `selectedCategory`.
      // We might need to update the view to support multiple categories or just use this for the single selection list.
      // For simplicity matching the UI request, let's say the dialog updates the horizontal list or just filters the content directly.
      // Let's make `selectedCategory` flexible or add a `filterMode` flag.
      // But re-reading the prompt, it seems like a standard filter.
      // Let's just use `selectedFilterCategories` to filter the displayed list in the view.
    }
    Get.back(); // Close dialog
  }

  void toggleSaved(Article article) {
    article.isSaved.value = !article.isSaved.value;
  }
}
