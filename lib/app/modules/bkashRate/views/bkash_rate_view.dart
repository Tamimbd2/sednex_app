import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/bkash_rate_controller.dart';

class BkashRateView extends GetView<BkashRateController> {
  const BkashRateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAE8EA), // Soft Pinkish Background
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [

                 Color(0xFFDC143C), // Primary Red
                 Color(0xFFB71C1C), // Darker Red
              ],
            ),
          ),
        ),
        title: Text(
          'Rate Calculator',
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
               color: Color(0xFFFAE8EA),
               borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
             ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
             // Last Update Section with Icon
            Center(
              child: Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(30),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.pink.withOpacity(0.1),
                       blurRadius: 10,
                       offset: const Offset(0, 4),
                     )
                   ]
                 ),
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     const Icon(Icons.history_rounded, color: Color(0xFFDC143C), size: 18),
                     const SizedBox(width: 8),
                     Text(
                       'Last Update: 15-03-2025',
                       style: GoogleFonts.poppins(
                         fontSize: 13,
                         color: const Color(0xFFDC143C),
                         fontWeight: FontWeight.w500,
                       ),
                     ),
                   ],
                 ),
              ),
            ),
            const SizedBox(height: 24),

            // Today's Rate Glass Card
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
                    color: const Color(0xFFDC143C).withOpacity(0.15),
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
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          ),
                          child: const Icon(Icons.currency_exchange, color: Color(0xFFDC143C)),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Today\'s Rate',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFDC143C),
                          ),
                        ),
                     ],
                   ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '৳124',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFDC143C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Calculator Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Currency Toggle Tabs
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Obx(() => Row(
                      children: [
                        _buildAnimatedTab(
                          '৳  BDT (Taka)', 
                          controller.isTakaSelected.value, 
                          () => controller.toggleCurrency(true)
                        ),
                        _buildAnimatedTab(
                          '\$  USD (Dollar)', 
                          !controller.isTakaSelected.value, 
                          () => controller.toggleCurrency(false)
                        ),
                      ],
                    )),
                  ),
                  const SizedBox(height: 24),

                  // Input Field with Label
                  Text(
                    'Amount to Send',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF616161),
                    ),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: controller.inputController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.poppins(
                       fontSize: 18,
                       fontWeight: FontWeight.w600,
                       color: const Color(0xFF424242),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.edit_rounded, color: Colors.grey.shade400, size: 20),
                      hintText: 'Enter amount...', 
                      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
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
                        borderSide: const BorderSide(color: Color(0xFFDC143C), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Amount Chips
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildModernChip('1k'),
                        const SizedBox(width: 10),
                        _buildModernChip('5k'),
                        const SizedBox(width: 10),
                        _buildModernChip('10k'),
                        const SizedBox(width: 10),
                        _buildModernChip('20k'),
                        const SizedBox(width: 10),
                        _buildModernChip('50k'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Fancy Divider with Swap Icon
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
                               color: Colors.grey.withOpacity(0.1),
                               blurRadius: 10,
                               offset: const Offset(0, 4),
                             )
                           ],
                           border: Border.all(color: const Color(0xFFFCE4EC), width: 2)
                         ),
                         child: const Icon(Icons.swap_vert_rounded, color: Color(0xFFDC143C), size: 24),
                       ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Output Section
                  Text(
                    'You Will Receive',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF616161),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                         BoxShadow(
                           color: Colors.blue.withOpacity(0.1),
                           blurRadius: 15,
                           offset: const Offset(0, 5)
                         )
                      ]
                    ),
                    child: Column(
                      children: [
                        Obx(() => Text(
                          controller.displayResult.value, 
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700, 
                            color: const Color(0xFF1565C0), 
                            height: 1.2,
                          ),
                        )),
                        const SizedBox(height: 4),
                        Text(
                          'Estimated Amount',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFF1976D2),
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

            // Note Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1), 
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFECCB)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFFFB8C00), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Note: ',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE65100), 
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: 'Commission rates may vary by location. Standard commission is 20 Tk per thousand.',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF5D4037),
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
    );
  }

  Widget _buildAnimatedTab(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected 
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
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
              color: isSelected ? const Color(0xFFDC143C) : const Color(0xFF9E9E9E),
            ),
          ),
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
               color: Colors.grey.withOpacity(0.05),
               blurRadius: 6,
               offset: const Offset(0, 2),
             )
          ]
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF616161),
          ),
        ),
      ),
    );
  }
}
