import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';

class BkashRateController extends GetxController {
  // State variables
  final isTakaSelected = true.obs; // Toggle between Taka (BDT) and USD input
  final inputController = TextEditingController();
  final displayResult = '0'.obs;
  
  // Observable rates from API
  final exchangeRate = 124.0.obs;
  final updateDate = ''.obs;

  final _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    fetchRates();
    // Listen to input changes to recalculate
    inputController.addListener(_calculateResult);
  }

  Future<void> fetchRates() async {
    try {
      final response = await _apiService.getData('api/homepage/services');
      if (response.statusCode == 200) {
        final body = response.body;
        List items = [];
        if (body is List) {
          items = body;
        } else if (body is Map) {
          if (body['cards'] is List) {
            items = body['cards'];
          } else if (body['services'] is List) {
            items = body['services'];
          }
        }

        for (var item in items) {
          final name = item['name']?.toString().toLowerCase() ?? '';
          if (name.contains('bkash')) {
            final rate = double.tryParse(item['rate']?.toString() ?? item['price']?.toString() ?? '124') ?? 124.0;
            exchangeRate.value = rate;
            updateDate.value = item['time']?.toString() ?? 
                               item['updatedAt']?.toString() ?? 
                               item['createdAt']?.toString() ?? '';
            _calculateResult(); // Recalculate with new rate
            break;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching bKash rates: $e");
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  // Toggle currency tab
  void toggleCurrency(bool isTaka) {
    isTakaSelected.value = isTaka;
    inputController.clear();
    displayResult.value = '0';
  }

  // Set predefined amount
  void setAmount(String amount) {
    // Remove 'k' and convert to thousands
    double value = double.tryParse(amount.replaceAll('k', '')) ?? 0;
    if (amount.toLowerCase().contains('k')) {
      value *= 1000;
    }
    inputController.text = value.toStringAsFixed(0);
  }

  // Calculation logic
  void _calculateResult() {
    String text = inputController.text;
    if (text.isEmpty) {
      displayResult.value = '0';
      return;
    }

    double inputAmount = double.tryParse(text) ?? 0;
    
    // User request: Same formula for USD/BDT - Pro-rated addition per thousand
    // Formula: inputAmount + (rate * (inputAmount / 1000))
    double multiplier = inputAmount / 1000.0;
    double result = inputAmount + (exchangeRate.value * multiplier);
    
    if (isTakaSelected.value) {
      displayResult.value = '৳${result.toStringAsFixed(2)}';
    } else {
      displayResult.value = '\$${result.toStringAsFixed(2)}';
    }
  }
}
