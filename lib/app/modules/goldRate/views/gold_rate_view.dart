import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/gold_rate_controller.dart';

class GoldRateView extends GetView<GoldRateController> {
  const GoldRateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Modern light background
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E63FF), // Red 700
                Color(0xFF3575FF), // Red 900
              ],
            ),
          ),
        ),
        title: Text(
          'Gold Rate',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FD),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // Top Section: Icon and Last Update
            Center(
              child: Column(
                children: [
                 Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1), // Light Gold
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        )
                      ]
                    ),
                    child: const Icon(Icons.monetization_on_rounded, color: Color(0xFFFFB300), size: 36),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.update, color: Color(0xFF757575), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Last Update: 15-03-2025', 
                          style: GoogleFonts.poppins(
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

            // Gold Rate Card (Premium Design)
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
                  // Gold Gradient Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                         colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)], 
                         begin: Alignment.centerLeft,
                         end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on, color: Color(0xFF1E63FF), size: 16),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Current Market Rate (BD)',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF5D4037),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Rates List
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _buildPremiumRateRow('1 Vori 22 Carat', '1,12,000 ৳', isHighlight: true),
                        _buildDivider(),
                        _buildPremiumRateRow('1 Vori 21 Carat', '1,07,000 ৳'),
                        _buildDivider(),
                        _buildPremiumRateRow('1 Vori 18 Carat', '92,000 ৳'),
                        _buildDivider(),
                        _buildPremiumRateRow('Traditional Method', '76,000 ৳'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Weight Conversion Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Weight Conversion & Calculation',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF263238),
                ),
              ),
            ),
            const SizedBox(height: 16),

             // Modern Tabs (Pill shaped)
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
                  _buildModernTab('Vori', 0),
                  _buildModernTab('Ana', 1),
                  _buildModernTab('Rati', 2),
                  _buildModernTab('Gram', 3),
                ],
              ),
            ),

            const SizedBox(height: 20),

             // Conversion Result Section
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
                border: Border.all(color: Colors.grey.withValues(alpha: 0.05)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                        '${controller.selectedTabName.value} Conversion Chart',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF37474F),
                        ),
                      )),
                      const Icon(Icons.calculate_outlined, color: Color(0xFF1E63FF), size: 24),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Measurement units are given below',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF90A4AE),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Conversion Items
                   Obx(() {
                    if (controller.selectedTabIndex.value == 0) { // Vori
                      return Column(
                        children: [
                           _buildModernConversionItem('1 Vori', '16 Ana'),
                           _buildModernConversionItem('1 Vori', '96 Rati'),
                           _buildModernConversionItem('1 Vori', '11.664 Gram'),
                        ]
                      );
                    } else if (controller.selectedTabIndex.value == 1) { // Ana
                       return Column(
                        children: [
                           _buildModernConversionItem('1 Ana', '6 Rati'),
                           _buildModernConversionItem('1 Ana', '0.729 Gram'),
                        ]
                      );
                    } else if (controller.selectedTabIndex.value == 2) { // Roti
                       return Column(
                        children: [
                           _buildModernConversionItem('1 Rati', '0.1215 Gram'),
                        ]
                      );
                    } else { // Gram
                       return Column(
                        children: [
                           _buildModernConversionItem('1 Gram', '0.0857 Vori'),
                        ]
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
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, thickness: 1, color: Colors.grey.withValues(alpha: 0.1)),
    );
  }

  Widget _buildPremiumRateRow(String title, String price, {bool isHighlight = false}) {
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
                color: isHighlight ? const Color(0xFFFFB300) : const Color(0xFFBDBDBD)
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isHighlight ? const Color(0xFF212121) : const Color(0xFF546E7A),
                ),
              ),
            ],
          ),
          Container( // Price Tag
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isHighlight ? const Color(0xFF1E63FF).withValues(alpha: 0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              price,
              style: GoogleFonts.poppins(
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

  Widget _buildModernTab(String title, int index) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedTabIndex.value == index;
        return GestureDetector(
          onTap: () => controller.changeTab(index, title),
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
                    )
                  ] 
                : null,
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: GoogleFonts.poppins(
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
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF546E7A),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E63FF), // Primary Red
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}



