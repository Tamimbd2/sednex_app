import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/number_helper.dart';
import '../controllers/gold_rate_controller.dart';

class GoldRateView extends GetView<GoldRateController> {
  const GoldRateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E63FF), Color(0xFF3575FF)],
            ),
          ),
        ),
        title: Text(
          'gold_rate'.tr,
          style: _getStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.rawRates.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshGoldRates,
          color: const Color(0xFF1E63FF),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.monetization_on_rounded,
                          color: Color(0xFFFFB300),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.update,
                              color: Color(0xFF757575),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'gold_last_update'.tr + controller.lastUpdate.value.trNum,
                              style: _getStyle(
                                fontSize: 13,
                                color: const Color(0xFF616161),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E63FF).withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFF1E63FF),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'current_market_rate'.tr,
                              style: _getStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF5D4037),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            if (controller.calculatedRates.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'no_data_found'.tr,
                                  style: _getStyle(color: Colors.grey),
                                ),
                              ),
                            ...controller.calculatedRates.asMap().entries.map((
                              entry,
                            ) {
                              final int idx = entry.key;
                              final Map<String, dynamic> rate = entry.value;
                              final String caratLabel = rate['carat'] == '1'
                                  ? 'sanatan'.tr
                                  : '${rate['carat'].toString().trNum} ${'carat'.tr}';

                              return Column(
                                children: [
                                  _buildPremiumRateRow(
                                    '1'.trNum + ' ${controller.selectedTabName.value.tr} $caratLabel',
                                    rate['price'].toString().trNum,
                                    isHighlight: idx == 0,
                                  ),
                                  if (idx <
                                      controller.calculatedRates.length - 1)
                                    _buildDivider(),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'weight_conversion_calculation'.tr,
                    style: _getStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF263238),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildModernTab('vhori'.tr, 0, 'vhori'),
                      _buildModernTab('ana'.tr, 1, 'ana'),
                      _buildModernTab('roti'.tr, 2, 'roti'),
                      _buildModernTab('gram'.tr, 3, 'gram'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withValues(alpha: 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.05),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Text(
                              '${controller.selectedTabName.value.tr} ${'conversion_chart'.tr}',
                              style: _getStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF37474F),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.calculate_outlined,
                            color: Color(0xFF1E63FF),
                            size: 24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'measurement_unit_below'.tr,
                        style: _getStyle(
                          fontSize: 12,
                          color: const Color(0xFF90A4AE),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        if (controller.selectedTabIndex.value == 0) {
                          return Column(
                            children: [
                              _buildModernConversionItem('1'.trNum + ' ${'vhori'.tr}', '16'.trNum + ' ${'ana'.tr}'),
                              _buildModernConversionItem('1'.trNum + ' ${'vhori'.tr}', '96'.trNum + ' ${'roti'.tr}'),
                              _buildModernConversionItem(
                                '1'.trNum + ' ${'vhori'.tr}',
                                '11.664'.trNum + ' ${'gram'.tr}',
                              ),
                            ],
                          );
                        } else if (controller.selectedTabIndex.value == 1) {
                          return Column(
                            children: [
                              _buildModernConversionItem('1'.trNum + ' ${'ana'.tr}', '6'.trNum + ' ${'roti'.tr}'),
                              _buildModernConversionItem(
                                '1'.trNum + ' ${'ana'.tr}',
                                '0.729'.trNum + ' ${'gram'.tr}',
                              ),
                            ],
                          );
                        } else if (controller.selectedTabIndex.value == 2) {
                          return Column(
                            children: [
                              _buildModernConversionItem(
                                '1'.trNum + ' ${'roti'.tr}',
                                '0.1215'.trNum + ' ${'gram'.tr}',
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _buildModernConversionItem(
                                '1'.trNum + ' ${'gram'.tr}',
                                '0.0857'.trNum + ' ${'vhori'.tr}',
                              ),
                            ],
                          );
                        }
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildPremiumRateRow(
    String title,
    String price, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: isHighlight
                    ? const Color(0xFFFFB300)
                    : const Color(0xFFBDBDBD),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: _getStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isHighlight
                      ? const Color(0xFF212121)
                      : const Color(0xFF546E7A),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isHighlight
                  ? const Color(0xFF1E63FF).withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              price,
              style: _getStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E63FF),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTab(String title, int index, String key) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedTabIndex.value == index;
        return GestureDetector(
          onTap: () => controller.changeTab(index, key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1E63FF) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1E63FF).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: _getStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF78909C),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildModernConversionItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_right_rounded, color: Color(0xFF90A4AE)),
              const SizedBox(width: 4),
              Text(
                label,
                style: _getStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF546E7A),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: _getStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E63FF),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _getStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return AppTextStyles.bodyMedium.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }
}
