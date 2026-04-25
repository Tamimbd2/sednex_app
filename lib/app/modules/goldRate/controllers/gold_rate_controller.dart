import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/url.dart';

class GoldRateController extends GetxController {
  final apiService = Get.find<ApiService>();

  // State
  final isLoading = true.obs;
  final rawRates = <Map<String, dynamic>>[].obs;
  final lastUpdate = ''.obs;

  // TAB State
  var selectedTabIndex = 0.obs;
  var selectedTabName = 'ভরি'.obs;

  // Measurement factors (relative to 1 Vori)
  final Map<int, double> factors = {
    0: 1.0,      // Vori
    1: 16.0,     // Ana
    2: 96.0,     // Rati
    3: 11.664,   // Gram
  };

  // Currency Symbol Mappings (API code -> Symbol)
  final Map<String, String> currencySymbols = {
    'aed': 'د.إ', 'bhd': '.د.ب', 'bdt': '৳', 'gbp': '£', 'ils': '₪',
    'iqd': 'ع.د', 'irr': '﷼', 'jod': 'د.ا', 'kwd': 'د.ك', 'lbp': 'ل.ل',
    'omr': '﷼', 'qar': '﷼', 'sar': '﷼', 'syp': '£', 'try': '₺',
    'usd': '\$', 'yer': '﷼'
  };

  @override
  void onInit() {
    super.onInit();
    fetchGoldRates();
  }

  Future<void> fetchGoldRates() async {
    try {
      isLoading.value = true;
      final response = await apiService.getData(AppUrl.goldRate);

      if (response.statusCode == 200) {
        var body = response.body;

        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            debugPrint('Error decoding JSON: $e');
          }
        }

        if (body is Map && body['rates'] is List) {
          final List ratesList = body['rates'];

          final List<Map<String, dynamic>> processed = [];
          for (var item in ratesList) {
            if (item is Map) {
              processed.add({
                'carat': item['carat']?.toString() ?? '?',
                'rawPrice': double.tryParse(item['price']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0,
                'currency': item['currency']?.toString().toLowerCase() ?? 'bdt',
              });
            }
          }

          rawRates.assignAll(processed);

          if (ratesList.isNotEmpty) {
            final firstItem = ratesList[0];
            final String? updateField = firstItem['updatedAt'] ?? firstItem['createdAt'];
            if (updateField != null) {
              try {
                final date = DateTime.parse(updateField).toLocal();
                lastUpdate.value = DateFormat('dd-MM-yyyy').format(date);
              } catch (e) {
                lastUpdate.value = updateField;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Exception fetching gold rates: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get calculatedRates {
    final double weightFactor = factors[selectedTabIndex.value] ?? 1.0;

    return rawRates.map((r) {
      final double perUnit = (r['rawPrice'] as double) / weightFactor;
      final String code = r['currency'] ?? 'bdt';
      final String symbol = currencySymbols[code] ?? symbolFromCode(code);

      return {
        'carat': r['carat'],
        'price': _formatPrice(perUnit, symbol),
      };
    }).toList();
  }

  String symbolFromCode(String code) {
    if (code == 'usd') return '\$';
    if (code == 'bdt') return '৳';
    return code.toUpperCase();
  }

  String _formatPrice(dynamic price, [String symbol = '৳']) {
    if (price == null || price.toString().isEmpty) return '0 $symbol';
    try {
      final double p = double.tryParse(price.toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      final formatter = NumberFormat('#,##,###');
      return '${formatter.format(p)}$symbol';
    } catch (e) {
      return '$price$symbol';
    }
  }

  Future<void> refreshGoldRates() => fetchGoldRates();

  void changeTab(int index, String name) {
    selectedTabIndex.value = index;
    selectedTabName.value = name;
  }
}
