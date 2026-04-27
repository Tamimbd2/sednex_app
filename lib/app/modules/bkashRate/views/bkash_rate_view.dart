import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/number_helper.dart';

import '../controllers/bkash_rate_controller.dart';

class BkashRateView extends GetView<BkashRateController> {
  const BkashRateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF4FF),
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
          'rate_calculator'.tr,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E63FF).withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.history_rounded,
                        color: Color(0xFF1E63FF),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        String dateStr = 'pending'.tr;
                        if (controller.updateDate.value.isNotEmpty) {
                          try {
                            DateTime dt = DateTime.parse(
                              controller.updateDate.value,
                            );
                            dateStr = "${dt.day}/${dt.month}/${dt.year}".trNum;
                          } catch (e) {
                            dateStr = 'N/A';
                          }
                        }
                        return Text(
                          'last_update'.tr + ': $dateStr',
                          style: _getStyle(
                            fontSize: 13,
                            color: const Color(0xFF1E63FF),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD12053).withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.currency_exchange,
                            color: Color(0xFFD12053),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'todays_bkash_rate'.tr,
                          style: _getStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD12053),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Obx(
                        () => Text(
                          '৳${controller.exchangeRate.value.toStringAsFixed(0).trNum}',
                          style: _getStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFD12053),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Obx(
                            () => AnimatedAlign(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutBack,
                              alignment: controller.isTakaSelected.value
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: FractionallySizedBox(
                                widthFactor: 0.5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              _buildAnimatedTab(
                                'bdt_taka'.tr,
                                controller.isTakaSelected,
                                true,
                                () => controller.toggleCurrency(true),
                              ),
                              _buildAnimatedTab(
                                'usd_dollar'.tr,
                                controller.isTakaSelected,
                                false,
                                () => controller.toggleCurrency(false),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'amount_to_send'.tr,
                      style: _getStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF616161),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.inputController,
                      keyboardType: TextInputType.number,
                      style: _getStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF424242),
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.edit_rounded,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        hintText: 'enter_amount'.tr,
                        hintStyle: _getStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFAFAFA),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF1E63FF),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildModernChip('1k'.trNum),
                          const SizedBox(width: 10),
                          _buildModernChip('5k'.trNum),
                          const SizedBox(width: 10),
                          _buildModernChip('10k'.trNum),
                          const SizedBox(width: 10),
                          _buildModernChip('20k'.trNum),
                          const SizedBox(width: 10),
                          _buildModernChip('50k'.trNum),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Divider(color: Colors.grey.shade200, thickness: 1.5),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFE3EEFF),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.swap_vert_rounded,
                            color: Color(0xFF1E63FF),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'amount_to_send_total'.tr,
                      style: _getStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF616161),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE3EEFF), Color(0xFF95C6FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1E63FF,
                            ).withValues(alpha: 0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Obx(
                            () => Text(
                              '৳' + controller.displayResult.value.trNum,
                              style: _getStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E63FF),
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'estimated_amount'.tr,
                            style: _getStyle(
                              fontSize: 12,
                              color: const Color(0xFF3575FF),
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
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFFFB300),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'note'.tr + ': ',
                              style: _getStyle(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFD48806),
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: 'bkash_commission_note'.tr,
                              style: _getStyle(
                                color: const Color(0xFF2C2C2C),
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTab(
    String title,
    RxBool selectedProp,
    bool isTaka,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Obx(() {
            final isSelected = selectedProp.value == isTaka;
            return AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: _getStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF1E63FF)
                    : const Color(0xFF9E9E9E),
              ),
              child: Text(title),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildModernChip(String label) {
    return GestureDetector(
      onTap: () => controller.setAmount(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: _getStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF616161),
          ),
        ),
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
