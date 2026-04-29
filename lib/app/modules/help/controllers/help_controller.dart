import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/services/api_service.dart';

class HelpController extends GetxController {
  late final ApiService _apiService;

  final isLoading = false.obs;
  final faqs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getData('api/about/faq/');

      if (response.status.hasError) {
        debugPrint('Error fetching FAQs: ${response.statusText}');
        return;
      }

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      if (body['success'] == true && body['faqs'] != null) {
        final List<dynamic> faqData = body['faqs'];
        faqs.value = faqData.map((item) {
          return {
            'id': item['id'],
            'question': item['question'] ?? 'No Question',
            'answer': item['answer'] ?? 'No Answer',
            'isExpanded': false.obs,
          };
        }).toList();

        if (faqs.isNotEmpty) {
          faqs[0]['isExpanded'].value = true;
        }
      }
    } catch (e) {
      debugPrint('Exception while fetching FAQs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFaq(int index) {
    faqs[index]['isExpanded'].value = !faqs[index]['isExpanded'].value;
  }
}
