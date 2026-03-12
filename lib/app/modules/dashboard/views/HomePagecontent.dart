import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../communityFeed/controllers/community_feed_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../namaj/controllers/namaj_controller.dart';
import '../../ramadancalander/controllers/ramadancalander_controller.dart';
import '../../../routes/app_pages.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});


  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    final CommunityFeedController feedController = Get.put(CommunityFeedController());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notice Bar
          Container(
            width: double.infinity,
            height: 36, // Constrained height for marquee
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: const Color(0xFFFFF0F0), // Light red background
            child: Obx(() {
              final controller = Get.find<DashboardController>();
              final text = controller.marqueeText.value;
              
              if (text.isEmpty) return const SizedBox();

              return Marquee(
                text: text, 
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 20.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              );
            }),
          ),

          // Hero Banner Frame
          // Hero Banner Frame
          Obx(() {
             final controller = Get.find<DashboardController>();
             final banners = controller.bannerList;
             
             if (banners.isEmpty) return const SizedBox.shrink();

             return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                   height: 150,
                   child: Stack(
                     children: [
                       PageView.builder(
                         controller: controller.bannerPageController,
                         onPageChanged: (index) => controller.currentBannerIndex.value = index,
                         itemCount: banners.length,
                         itemBuilder: (context, index) {
                           return Container(
                             margin: const EdgeInsets.symmetric(horizontal: 0),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(16),
                               image: DecorationImage(
                                 image: NetworkImage(banners[index]),
                                 fit: BoxFit.cover,
                               ),
                             ),
                           );
                         },
                       ),
                       // Indicators
                       if (banners.length > 1)
                         Positioned(
                           bottom: 10,
                           left: 0, 
                           right: 0,
                           child: Obx(() => Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: List.generate(banners.length, (index) {
                                 final isActive = controller.currentBannerIndex.value == index;
                                 return AnimatedContainer(
                                   duration: const Duration(milliseconds: 300),
                                   margin: const EdgeInsets.symmetric(horizontal: 4),
                                   width: isActive ? 20 : 8,
                                   height: 8,
                                   decoration: BoxDecoration(
                                     color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                                     borderRadius: BorderRadius.circular(4),
                                   ),
                                 );
                             }),
                           )),
                         ),
                     ],
                   ),
                ),
             );
          }),

          // Information & Services Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Text(
                  'Information & Services',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101727),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF101727))
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Service Cards Row (Scrollable)
          SizedBox(
            height: 170, // Reduced from 200 as requested
            child: Obx(() {
               final dController = Get.find<DashboardController>();
               final services = dController.servicesList;
               
               return ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Sehri & Iftar Card
                  _buildSehriIftarCompactCard(),
                  const SizedBox(width: 12),
                  
                  // Fazar Card (Mosque)
                  SizedBox(
                    width: 120,
                    child: Obx(() {
                      NamajController? controller;
                      try {
                        controller = Get.find<NamajController>();
                      } catch (e) {}
                      
                      final nextPrayer = controller?.nextPrayerDisplay ?? {'name': 'Fazar', 'time': '05:45 AM'};
                      
                      return _buildServiceCard(
                        title: nextPrayer['name']!,
                        subtitle: nextPrayer['time']!,
                        subtitleColor: const Color(0xFF2E7D32), // Green
                        footerText: 'today',
                        imagePath: 'assets/logo/mosque.png',
                        bgColor: const Color(0xFFE0F2F1), // Light Teal
                        iconSize: 60,
                        onTap: () => Get.toNamed('/namaj'),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  
                  // Dynamic Services from API
                  ...services.map((service) {
                      String name = service['name']?.toString() ?? 'Service';
                      
                      // Handle price/rate with currency
                      String subtitle = '';
                      if (service['price'] != null) {
                         subtitle = '${service['price']}';
                      } else if (service['rate'] != null) {
                         subtitle = '${service['rate']}';
                      } else {
                         subtitle = service['value']?.toString() ?? '0';
                      }
                      
                      // Append currency symbol based on type
                      if (name.toLowerCase().contains('bkash')) {
                         subtitle += '৳';
                      } else if (name.toLowerCase().contains('gold')) {
                         subtitle += '£'; 
                      }

                      String image = service['icon']?.toString() ?? service['image']?.toString() ?? '';
                      
                      // Dynamic Styling
                      Color bgColor = const Color(0xFFE3F2FD); // Default Light Blue
                      Color subColor = const Color(0xFF1565C0);
                      
                      if (name.toLowerCase().contains('bkash')) {
                         bgColor = const Color(0xFFFCE4EC); // Light Pink
                         subColor = const Color(0xFFC2185B); // Pink
                      } else if (name.toLowerCase().contains('gold')) {
                         bgColor = const Color(0xFFFFF3E0); // Light Orange
                         subColor = const Color(0xFF101727); // Dark
                      }

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           SizedBox(
                             width: 120,
                             child: _buildServiceCard(
                               title: name,
                               subtitle: subtitle,
                               subtitleColor: subColor,
                               footerText: 'today',
                               imagePath: image,
                               bgColor: bgColor,
                               iconSize: 50,
                               onTap: () {
                                  if (name.toLowerCase().contains('bkash')) {
                                     Get.toNamed(Routes.BKASH_RATE);
                                  } else if (name.toLowerCase().contains('gold')) {
                                     Get.toNamed(Routes.GOLD_RATE);
                                  }
                               },
                             ),
                           ),
                           const SizedBox(width: 12),
                        ],
                      );
                  }),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          // Essential Services Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Essential Services',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101727),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed('/essential-service'),
                  child: Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8F95A1),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Essential Services Horizontal List
          SizedBox(
            height: 110, // Height for icon + text
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildEssentialServiceItem(
                  'Informations',
                  'assets/essentialService/informations.png',
                  const Color(0xFF4169E1),
                  () => Get.toNamed('/informations'),
                ),
                const SizedBox(width: 16),
                _buildEssentialServiceItem(
                  'Embassy',
                  'assets/essentialService/embassy.png',
                  const Color(0xFFDC143C),
                  () => Get.toNamed('/embassy'),
                ),
                const SizedBox(width: 16),
                _buildEssentialServiceItem(
                  'Article',
                  'assets/essentialService/article.png',
                  const Color(0xFFFFA500),
                  () => Get.toNamed('/articles'),
                ),
                const SizedBox(width: 16),
                _buildEssentialServiceItem(
                  'Basic Goods',
                  'assets/essentialService/basicgoods.png',
                  const Color(0xFF20B2AA),
                  () => Get.toNamed('/basicgoods'),
                ),
                const SizedBox(width: 16),
                _buildEssentialServiceItem(
                  'Community',
                  'assets/essentialService/community.png',
                  const Color(0xFF4169E1),
                  () => Get.toNamed('/community'),
                ),
              ],
            ),
          ),
          
          // Community Feed Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Community Feed',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101727),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed('/community-feed'),
                  child: Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8F95A1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Community Feeds List
          Obx(() {
            if (feedController.posts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('No posts available')),
              );
            }
            
            // Show only first 3 posts
            final displayPosts = feedController.posts.take(3).toList();
            
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: displayPosts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                // We need to pass the methods from CommunityFeedView or reimplement them.
                // Reimplementing simplified version for Dashboard.
                final post = displayPosts[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                       BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(post['avatar']),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['name'],
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF101727),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      post['time'],
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF697282),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    if (post['category'] != null) ...[
                                      const SizedBox(width: 8),
                                      _buildCategoryTag(post['category']),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Content
                      Text(
                        post['content'],
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF354152),
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Images
                      if (post['images'] != null && (post['images'] as List).isNotEmpty)
                        _buildPostImages(post['images']),
                        
                      const SizedBox(height: 12),
                      
                      // Footer (Stats only)
                      Row(
                        children: [
                          const Icon(Icons.favorite, size: 16, color: Color(0xFFDC143C)),
                          const SizedBox(width: 4),
                          Text('${post['likes']}', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFDC143C))),
                          const SizedBox(width: 16),
                          SvgPicture.asset('assets/post/comment.svg', width: 14, height: 14, colorFilter: const ColorFilter.mode(Color(0xFF495565), BlendMode.srcIn)),
                          const SizedBox(width: 4),
                          Text('${post['comments']}', style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF495565))),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEssentialServiceItem(
    String label,
    String imagePath,
    Color backgroundColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF354152),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTag(String category) {
    Color bgColor;
    switch (category) {
      case 'Question':
        bgColor = const Color(0xFFFF7F00); // Orange
        break;
      case 'Sell':
        bgColor = const Color(0xFF22C55E); // Green
        break;
      case 'Info':
        bgColor = const Color(0xFFA855F7); // Purple
        break;
      case 'Jobs':
        bgColor = Colors.blue;
        break;
      case 'Rentals':
        bgColor = Colors.teal;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPostImages(List<dynamic> images) {
    int count = images.length;
    if (count == 0) return const SizedBox.shrink();
    
    return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 200, // Reduced height for dashboard preview
          child: _buildLayout(images, count),
        ),
    );
  }

  Widget _buildLayout(List<dynamic> images, int count) {
    if (count == 1) {
      return _buildImage(images[0]);
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(child: _buildImage(images[0])),
          const SizedBox(width: 4),
          Expanded(child: _buildImage(images[1])),
        ],
      );
    } else if (count == 3) {
      return Row(
        children: [
          Expanded(child: _buildImage(images[0])),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _buildImage(images[1])),
                const SizedBox(height: 4),
                Expanded(child: _buildImage(images[2])),
              ],
            ),
          ),
        ],
      );
    } else {
      // 4 or more
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                 Expanded(child: _buildImage(images[0])),
                 const SizedBox(width: 4),
                 Expanded(child: _buildImage(images[1])),
              ],
            ),
          ),
          const SizedBox(height: 4),
           Expanded(
            child: Row(
              children: [
                 Expanded(child: _buildImage(images[2])),
                 const SizedBox(width: 4),
                 Expanded(
                   child: count > 4 
                     ? Stack(
                         fit: StackFit.expand,
                         children: [
                           _buildImage(images[3]),
                           Container(
                             color: Colors.black54,
                             alignment: Alignment.center,
                             child: Text(
                               "+${count - 4}",
                               style: GoogleFonts.poppins(
                                 color: Colors.white,
                                 fontSize: 24,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           )
                         ],
                       )
                     : _buildImage(images[3]),
                 ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required Color subtitleColor,
    required String footerText,
    required String imagePath,
    required Color bgColor,
    double iconSize = 50,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (imagePath.startsWith('http'))
              Image.network(
                imagePath,
                height: iconSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: iconSize, color: Colors.grey),
              )
            else
              Image.asset(
                imagePath,
                height: iconSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: iconSize, color: Colors.grey),
              ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF354152),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 16, // Slightly smaller to fit
                fontWeight: FontWeight.w700,
                color: subtitleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, size: 12, color: Color(0xFFDC143C)),
                const SizedBox(width: 4),
                Text(
                  footerText,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFFDC143C),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSehriIftarCompactCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.RAMADANCALANDER),
      child: Container(
        width: 120, // Increased width slightly to fit header text
        height: 175, // Reduced height as requested
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFD4F3D8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Obx(() {
          RamadancalanderController? rController;
          try {
            rController = Get.find<RamadancalanderController>();
          } catch(e) {}
          
          final data = rController?.todayRamadanData ?? {
            'date': '18 Feb',
            'seheri': '04:55 AM',
            'iftar': '5:26 PM',
            'location': 'Beirut'
          };
          
          return Column(
          children: [
          // Date and Location Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 8, color: Colors.black),
                    const SizedBox(width: 2),
                    Text(
                      data['date']!.split(' 2026')[0], // Shorten date if needed
                      style: GoogleFonts.poppins(fontSize: 7, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Row(
                   children: [
                     const Icon(Icons.location_on_outlined, size: 8, color: Colors.black),
                     const SizedBox(width: 2),
                     Text(
                       data['location']!,
                       style: GoogleFonts.poppins(fontSize: 7, fontWeight: FontWeight.w500),
                     ),
                   ],
                 ),
               ),
            ],
          ),
          const SizedBox(height: 6),
          // Sehri Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       // Using Icon as fallback since SVG has unsupported embedded bitmap
                       Image.asset('assets/images/sheheri.png', width: 22, height: 22),
                       const SizedBox(width: 4),
                       Text(
                         'Seheri',
                         style: GoogleFonts.poppins(
                           fontSize: 10,
                           fontWeight: FontWeight.w600,
                           color: Colors.black87,
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(height: 2),
                   Text(
                     data['seheri']!,
                     style: GoogleFonts.poppins(
                       fontSize: 13,
                       fontWeight: FontWeight.bold,
                       color: const Color(0xFF2E7D32),
                     ),
                   ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Iftar Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       // Using Icon as fallback since SVG has unsupported embedded bitmap
                       Image.asset('assets/images/ifter.png', width: 22, height: 22),
                       const SizedBox(width: 4),
                       Text(
                         'Ifter',
                         style: GoogleFonts.poppins(
                           fontSize: 10,
                           fontWeight: FontWeight.w600,
                           color: Colors.black87,
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(height: 2),
                   Text(
                     data['iftar']!,
                     style: GoogleFonts.poppins(
                       fontSize: 13,
                       fontWeight: FontWeight.bold,
                       color: const Color(0xFF2E7D32),
                     ),
                   ),
                ],
              ),
            ),
          ),
        ],
      );
      }),
    ),
    );
  }
}
