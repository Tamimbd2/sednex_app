import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BkashRateController extends GetxController {
  // State variables
  final isTakaSelected = true.obs; // Toggle between Taka (BDT) and USD input
  final inputController = TextEditingController();
  final displayResult = '0'.obs;
  
  // Hardcoded rate for now, can be fetched from API later
  final exchangeRate = 124.0; 

  @override
  void onInit() {
    super.onInit();
    // Listen to input changes to recalculate
    inputController.addListener(_calculateResult);
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
    double result;

    if (isTakaSelected.value) {
      // Input is Taka, convert to USD
      // Assuming rate is Taka per USD. So Taka / Rate = USD
      // Wait, usually the rate displayed "124" means 1 USD = 124 BDT.
      // So if I input 124 Taka, I get 1 USD.
      result = inputAmount / exchangeRate;
      displayResult.value = '\$${result.toStringAsFixed(2)}';
    } else {
      // Input is USD, convert to Taka
      // USD * Rate = Taka
      result = inputAmount * exchangeRate;
      displayResult.value = '৳${result.toStringAsFixed(2)}';
    }
  }
}
