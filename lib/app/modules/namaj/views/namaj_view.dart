import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/namaj_controller.dart';

class NamajView extends GetView<NamajController> {
  const NamajView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC143C), // Crimson Red
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'নামাজের সময়সূচি',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Update
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Color(0xFF6F6F6F)),
                const SizedBox(width: 8),
                Obx(() => Text(
                  'Last Update: ${controller.schedule['lastUpdate']}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF6F6F6F),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 16),

            // Schedule Card
            _buildScheduleCard(),

            const SizedBox(height: 24),

            // Prayer Learning Header
            _buildSectionHeader('নামাজ শিক্ষা (সংক্ষেপে)', Icons.menu_book_outlined),
            
            const SizedBox(height: 16),

            // Prayer Learning Grid
            _buildPrayerLearningGrid(),

            const SizedBox(height: 24),

            // Essential Duas Header
             _buildSectionHeader('প্রয়োজনীয় দোয়া', Icons.favorite_border),

            const SizedBox(height: 16),

            // Duas List
            _buildDuasList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFDC143C)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                '${controller.schedule['day']}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFDC143C),
                ),
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC143C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Obx(() => Text(
                  '${controller.schedule['status']}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Table Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScheduleColumnHeader('ফজর'),
              _buildScheduleColumnHeader('যোহর'),
              _buildScheduleColumnHeader('আছর', isHighlight: true),
              _buildScheduleColumnHeader('মাগরিব'),
              _buildScheduleColumnHeader('ঈশা'),
            ],
          ),
           const SizedBox(height: 8),
           // Table Times
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               ...List.generate(5, (index) {
                 final times = controller.schedule['prayers'] as List;
                 final isHighlight = index == 2; // Assuming Asr is highlighted as per screenshot
                 return Text(
                   times[index]['time'],
                   style: GoogleFonts.poppins(
                     fontSize: 14,
                     fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
                     color: isHighlight ? const Color(0xFFDC143C) : const Color(0xFF333333),
                   ),
                 );
               })
            ]
           )
        ],
      ),
    );
  }

  Widget _buildScheduleColumnHeader(String text, {bool isHighlight = false}) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isHighlight ? const Color(0xFFDC143C) : const Color(0xFF828282),
      ),
    );
  }

  Widget _buildPrayerLearningGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: controller.prayerSections.length,
      itemBuilder: (context, index) {
        final item = controller.prayerSections[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(item['color'] as int),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // Icon placeholder if asset not available, else Image.asset
                   Container(
                     width: 40,
                     height: 40,
                     alignment: Alignment.centerLeft,
                     child: Image.asset(
                          item['icon'] as String,
                          errorBuilder: (c, o, s) => Icon(Icons.wb_sunny_outlined, color: Color(item['textColor'] as int), size: 30),
                        ),
                   ),

                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Text(
                    item['rakat'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(Icons.chevron_right, color: Colors.grey[400]),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildDuasList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.duas.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final dua = controller.duas[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEEE)),
             boxShadow: const [
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                dua['title']!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFDC143C),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  dua['arabic']!,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri( // Use Arabic font if possible, fallback to default
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 12),
               Text(
                dua['bangla']!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF555555),
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
