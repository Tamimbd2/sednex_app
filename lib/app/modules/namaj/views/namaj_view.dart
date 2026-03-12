import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/namaj_controller.dart';
import 'fazar.dart';
import 'zohar.dart';
import 'achar.dart';
import 'magrib.dart';
import 'esha.dart';
import 'quran.dart';

class NamajView extends GetView<NamajController> {
  const NamajView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDC143C), Color(0xFFB71C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'নামাজের সময়সূচি',
          style: GoogleFonts.hindSiliguri(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Update Pill
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF6F6F6F)),
                    const SizedBox(width: 6),
                    Obx(() => Text(
                      'Last Update: ${controller.schedule['lastUpdate']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF6F6F6F),
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Schedule Card
            _buildScheduleCard(),

            const SizedBox(height: 28),

            // Prayer Learning Header
            _buildSectionHeader('নামাজ শিক্ষা (সংক্ষেপে)', 'assets/icons/book.svg'), // Using fallback icon logic
            
            const SizedBox(height: 16),

            // Prayer Learning Grid
            _buildPrayerLearningGrid(),

            const SizedBox(height: 28),

            // Essential Duas Header
             _buildSectionHeader('প্রয়োজনীয় দোয়া', 'assets/icons/heart.svg'),

            const SizedBox(height: 16),

            // Duas List
            _buildDuasList(),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String iconPath) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFDC143C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
             // Since we don't have the exact SVG paths for generic icons, using standard Icons for now
             iconPath.contains('book') ? Icons.menu_book_rounded : Icons.favorite_rounded,
             size: 20, 
             color: const Color(0xFFDC143C)
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.hindSiliguri(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF101727),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC143C).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFDC143C).withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: const Color(0xFFDC143C).withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFFDC143C)),
                    const SizedBox(width: 8),
                    Obx(() => Text(
                      '${controller.schedule['day']}',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101727),
                      ),
                    )),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDC143C), Color(0xFFFF5252)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDC143C).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Obx(() => Text(
                    '${controller.schedule['status']}',
                    style: GoogleFonts.hindSiliguri(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                ),
              ],
            ),
          ),
          
          // Times Table
          Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              final currentIndex = controller.currentPrayerIndex.value;
              return Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildScheduleColumnHeader('ফজর', isHighlight: currentIndex == 0),
                      _buildScheduleColumnHeader('যোহর', isHighlight: currentIndex == 1),
                      _buildScheduleColumnHeader('আছর', isHighlight: currentIndex == 2),
                      _buildScheduleColumnHeader('মাগরিব', isHighlight: currentIndex == 3),
                      _buildScheduleColumnHeader('ঈশা', isHighlight: currentIndex == 4),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, color: Colors.grey.shade100),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       ...List.generate(5, (index) {
                         final times = controller.schedule['prayers'] as List;
                         final isHighlight = index == currentIndex; 
                         return Container(
                           padding: isHighlight ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4) : null,
                           decoration: isHighlight ? BoxDecoration(
                             color: const Color(0xFFDC143C).withOpacity(0.1),
                             borderRadius: BorderRadius.circular(8),
                           ) : null,
                           child: Text(
                             times[index]['time'],
                             style: GoogleFonts.poppins(
                               fontSize: 14,
                               fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
                               color: isHighlight ? const Color(0xFFDC143C) : const Color(0xFF333333),
                             ),
                           ),
                         );
                       })
                    ]
                  )
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleColumnHeader(String text, {bool isHighlight = false}) {
    return Text(
      text,
      style: GoogleFonts.hindSiliguri(
        fontSize: 13,
        fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
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
        childAspectRatio: 1.35,
      ),
      itemCount: controller.prayerSections.length,
      itemBuilder: (context, index) {
        final item = controller.prayerSections[index];
        final color = Color(item['color'] as int);
        final textColor = Color(item['textColor'] as int);
        
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: textColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final title = item['title'];
                if (title == 'ফজর') {
                  Get.to(() => const FajarView());
                } else if (title == 'যোহর') {
                  Get.to(() => const ZoharView());
                } else if (title == 'আছর') {
                  Get.to(() => const AcharView());
                } else if (title == 'মাগরিব') {
                   Get.to(() => const MagribView()); 
                } else if (title == 'ঈশা') {
                  Get.to(() => const EshaView());
                } else if (title == 'কুরআন') {
                  Get.to(() => const QuranView());
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Decorative Circle
                  Positioned(
                    right: -20,
                    top: -20,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Container(
                           width: 44,
                           height: 44,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             shape: BoxShape.circle,
                             boxShadow: [
                               BoxShadow(
                                 color: textColor.withOpacity(0.2),
                                 blurRadius: 8,
                                 offset: const Offset(0, 2),
                               ),
                             ],
                           ),
                           alignment: Alignment.center,
                           child: Icon(
                                item['icon'] as IconData,
                                color: textColor,
                                size: 24,
                              ),
                         ),
                  
                        const Spacer(),
                        Text(
                          item['title'] as String,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF101727),
                          ),
                        ),
                        Text(
                          item['rakat'] as String,
                          style: GoogleFonts.hindSiliguri(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF697282),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Icon(Icons.arrow_forward_rounded, size: 20, color: textColor.withOpacity(0.7)),
                  )
                ],
              ),
            ),
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // Header
               Container(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                 decoration: BoxDecoration(
                   color: const Color(0xFFF9FAFB),
                   borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                   border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                 ),
                 child: Row(
                   children: [
                     Container(
                       width: 4, 
                       height: 16, 
                       decoration: BoxDecoration(
                         color: const Color(0xFFDC143C),
                         borderRadius: BorderRadius.circular(2),
                       ),
                     ),
                     const SizedBox(width: 8),
                     Expanded(
                       child: Text(
                        dua['title']!,
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF101727),
                        ),
                                           ),
                     ),
                   ],
                 ),
               ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Arabic Container
                    Container(
                      padding: const EdgeInsets.all(20),
                       decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F8), // Very light warm background
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFDC143C).withOpacity(0.08)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  dua['arabic']!,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.amiri(
                                    fontSize: 22,
                                    height: 1.6,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF101727),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                           Align(
                             alignment: Alignment.bottomLeft,
                             child: InkWell(
                               onTap: () {
                                 Clipboard.setData(ClipboardData(text: dua['arabic']!));
                                 Get.snackbar(
                                   'Copied', 
                                   'Dua copied to clipboard',
                                   snackPosition: SnackPosition.BOTTOM,
                                   margin: const EdgeInsets.all(16),
                                   backgroundColor: const Color(0xFF333333),
                                   colorText: Colors.white,
                                   duration: const Duration(seconds: 1),
                                 );
                               },
                               child: Padding(
                                 padding: const EdgeInsets.all(4.0),
                                 child: Row(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Icon(Icons.copy_rounded, size: 14, color: const Color(0xFFDC143C).withOpacity(0.7)),
                                     const SizedBox(width: 4),
                                     Text(
                                       'Copy',
                                       style: GoogleFonts.poppins(
                                         fontSize: 10,
                                         color: const Color(0xFFDC143C).withOpacity(0.7),
                                         fontWeight: FontWeight.w500,
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Translation
                     Text(
                      dua['bangla']!,
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF495565),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
