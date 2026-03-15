import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class HelpController extends GetxController {
  final _connect = GetConnect();
  final _box = GetStorage();

  final isLoading = false.obs;
  final faqs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;
      final token =
          _box.read('token') ??
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTk5MzhmYjViNWJjMmM1YjEyMzYyY2QiLCJlbWFpbCI6ImFmc2FyQHNlZG5leC5jb20iLCJyb2xlIjoidXNlciIsImlhdCI6MTc3Mjg2MTYzMiwiZXhwIjoxNzczNDY2NDMyfQ.PuRUjybyM9EzP2ICL0X_SXoSx8PwDOlJh0XrSi5fiwU';
      final response = await _connect.get(
        '${AppUrl.baseUrl}api/about/faq/',
        headers: {'Authorization': 'Bearer $token'},
      );

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
