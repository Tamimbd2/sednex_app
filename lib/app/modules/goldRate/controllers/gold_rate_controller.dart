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
  final usdToBdtRate = 120.0.obs; // Fallback conversion rate

  // TAB State
  var selectedTabIndex = 0.obs;
  var selectedTabName = 'vhori'.obs;

  // Measurement factors (relative to 1 Vori)
  // Standard gold rates are stored per Gram on server (since 165 USD is spot price of ~1g / 0.0857 vhori).
  // 1 Vori = 11.664 Grams.
  // 1 Vori = 16 Ana.
  // 1 Vori = 96 Roti.
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
      
      // 1. Fetch live USD to BDT exchange rate
      try {
        final exResponse = await apiService.get('https://open.er-api.com/v6/latest/USD');
        if (exResponse.statusCode == 200 && exResponse.body is Map) {
          final rates = exResponse.body['rates'];
          if (rates is Map && rates['BDT'] != null) {
            final double? rateVal = double.tryParse(rates['BDT'].toString());
            if (rateVal != null && rateVal > 0) {
              usdToBdtRate.value = rateVal;
              debugPrint('Live USD to BDT exchange rate fetched: $rateVal');
            }
          }
        }
      } catch (e) {
        debugPrint('Could not fetch live exchange rate, using fallback: $e');
      }

      // 2. Fetch Gold rates from Sednex server
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
      double rawPrice = r['rawPrice'] as double;
      String code = r['currency'] ?? 'bdt';

      // Convert USD per gram to BDT per gram
      if (code == 'usd') {
        rawPrice = rawPrice * usdToBdtRate.value;
        code = 'bdt'; // Show currency as BDT (৳)
      }

      // Backend price is per Gram. 
      // If Vhori is selected (weightFactor = 1.0 relative to Vhori): 
      // Vhori price = Gram price * 11.664
      final double priceInVhori = rawPrice * 11.664;
      final double perUnit = priceInVhori / weightFactor;
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
      return '${formatter.format(p.round())}$symbol';
    } catch (e) {
      return '$price$symbol';
    }
  }

  Future<void> refreshGoldRates() => fetchGoldRates();

  void changeTab(int index, String key) {
    selectedTabIndex.value = index;
    selectedTabName.value = key;
  }
}
