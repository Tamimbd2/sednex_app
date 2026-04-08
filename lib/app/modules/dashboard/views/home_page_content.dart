import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../communityFeed/controllers/community_feed_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../namaj/controllers/namaj_controller.dart';
import '../../ramadancalander/controllers/ramadancalander_controller.dart';

import '../../../routes/app_pages.dart';
import '../../communityFeed/widgets/community_post_card.dart';
import '../../../core/theme/app_colors.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    final CommunityFeedController feedController = Get.put(
      CommunityFeedController(),
    );

    final dashboardController = Get.find<DashboardController>();

    return SingleChildScrollView(
      controller: dashboardController.homeScrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notice Bar
          Container(
            width: double.infinity,
            height: 36, // Constrained height for marquee
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            color: AppColors.backgroundAlt, // Light blue background (BG 1)
            child: Obx(() {
              final controller = Get.find<DashboardController>();
              final text = controller.marqueeText.value;

              if (text.isEmpty) return const SizedBox();

              return Marquee(
                text: text,
                style:
                    GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ).copyWith(
                      fontFamilyFallback: [
                        GoogleFonts.hindSiliguri().fontFamily!,
                      ],
                    ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 20.0,
                velocity: 50.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 0.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.linear,
                decelerationDuration: const Duration(milliseconds: 500),
                decelerationCurve: Curves.easeOut,
              );
            }),
          ),

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
                      onPageChanged: (index) =>
                          controller.currentBannerIndex.value = index,
                      itemCount: 10000,
                      itemBuilder: (context, index) {
                        final actualIndex = index % banners.length;
                        final banner = banners[actualIndex];
                        return GestureDetector(
                          onTap: () async {
                            String urlStr = banner['url']?.toString() ?? '';
                            debugPrint('Hero Banner: Tapped! URL: "$urlStr"');

                            if (urlStr.isNotEmpty) {
                              // Standardize URL schema if missing
                              if (!urlStr.startsWith('http')) {
                                urlStr = 'https://$urlStr';
                              }

                              final Uri uri = Uri.parse(urlStr);
                              if (await canLaunchUrl(uri)) {
                                debugPrint('Hero Banner: Launching $urlStr');
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                debugPrint(
                                  'Hero Banner: Could not launch $urlStr',
                                );
                                // Try launching even if canLaunchUrl fails (can happen)
                                try {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } catch (e) {
                                  debugPrint(
                                    'Hero Banner: Final error launching $urlStr: $e',
                                  );
                                }
                              }
                            } else {
                              debugPrint(
                                'Hero Banner: URL is empty, nothing to redirect.',
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  banner['image'] ?? '',
                                ),
                                fit: BoxFit.cover,
                              ),
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
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(banners.length, (index) {
                              final isActive =
                                  (controller.currentBannerIndex.value %
                                      banners.length) ==
                                  index;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: isActive ? 20 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                        ),
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
                  'information_services'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF2C2C2C),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Information & Services Carousel
          Column(
            children: [
              SizedBox(
                height: 175,
                child: Obx(() {
                  final dController = Get.find<DashboardController>();
                  final services = dController.servicesList;

                  // Construct static + dynamic items
                  final List<Widget> items = [];

                  // 1. Namaj Card
                  items.add(
                    SizedBox(
                      width: 120,
                      child: Obx(() {
                        NamajController? nController;
                        try {
                          nController = Get.find<NamajController>();
                        } catch (e) {}
                        final nextPrayer =
                            nController?.nextPrayerDisplay ??
                            {'name': 'Fazar', 'time': '05:45 AM'};
                        return _buildServiceCard(
                          title: nextPrayer['name']!,
                          subtitle: nextPrayer['time']!,
                          subtitleColor: const Color(0xFF2E7D32),
                          footerText: 'today'.tr,
                          imagePath: 'assets/logo/mosque.png',
                          bgColor: const Color(0xFFE0F2F1),
                          iconSize: 60,
                          onTap: () => Get.toNamed('/namaj'),
                        );
                      }),
                    ),
                  );

                  // 2. Sehri Iftar Compact Card
                  RamadancalanderController? rController;
                  try {
                    rController = Get.find<RamadancalanderController>();
                  } catch (e) {
                    rController = Get.put(RamadancalanderController());
                  }

                  if (rController?.isRamadanActive.value ?? false) {
                    items.add(_buildSehriIftarCompactCard());
                  }

                  // 3. Dynamic Services (Filtering generic ramadan cards)
                  items.addAll(
                    services.where((service) {
                      String name = (service['name'] ?? '').toString().toLowerCase();
                      return !name.contains('ramadan');
                    }).map((service) {
                      String name = service['name']?.toString() ?? 'Service';
                      String image =
                          service['icon']?.toString() ??
                          service['image']?.toString() ??
                          '';
                      var rawRate =
                          service['rate'] ??
                          service['price'] ??
                          service['value'];
                      String rateStr = rawRate?.toString() ?? '';
                      bool isBkash =
                          name.toLowerCase().contains('bkash') ||
                          image.toLowerCase().contains('bkash') ||
                          rateStr.startsWith('124') ||
                          (name.toLowerCase() == 'gold rate' &&
                              !image.toLowerCase().contains('gold'));
                      bool isGold =
                          !isBkash && name.toLowerCase().contains('gold');
                      String subtitle =
                          (service['price'] ??
                                  service['rate'] ??
                                  service['value'] ??
                                  '0')
                              .toString();
                      if (isBkash) {
                        subtitle += '৳';
                      } else if (isGold) {
                        subtitle += '£';
                      }
                      Color bgColor = isBkash
                          ? const Color(0xFFFCE4EC)
                          : (isGold
                                ? const Color(0xFFFFF3E0)
                                : const Color(0xFFE3F2FD));
                      Color subColor = isBkash
                          ? const Color(0xFFC2185B)
                          : (isGold
                                ? const Color(0xFF101727)
                                : const Color(0xFF1565C0));
                      String displayName =
                          isBkash && name.toLowerCase().contains('gold')
                          ? 'bKash Rate'
                          : name;
                      String rawDate =
                          service['time']?.toString() ??
                          service['updatedAt']?.toString() ??
                          service['createdAt']?.toString() ??
                          '';
                      String formattedDate = 'today';
                      if (rawDate.isNotEmpty) {
                        try {
                          // Standardize format (4 Apr 26) manually
                          DateTime dt = DateTime.parse(rawDate);
                          final months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec',
                          ];
                          String d = dt.day.toString();
                          String m = months[dt.month - 1];
                          String y = dt.year.toString().substring(2);
                          formattedDate = '$d $m $y';
                        } catch (e) {
                          formattedDate = 'today'.tr;
                        }
                      }

                      return SizedBox(
                        width: 120,
                        child: _buildServiceCard(
                          title: displayName,
                          subtitle: subtitle,
                          subtitleColor: subColor,
                          footerText: formattedDate,
                          imagePath: image,
                          bgColor: bgColor,
                          iconSize: 50,
                          onTap: () => Get.toNamed(
                            isBkash ? Routes.BKASH_RATE : Routes.GOLD_RATE,
                          ),
                        ),
                      );
                    }),
                  );

                  return ListView.separated(
                    controller: dController.infoScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (items.isEmpty) return const SizedBox();
                      return items[index];
                    },
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Essential Services Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'essential_services'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed('/essential-service'),
                  child: Text(
                    'view_all'.tr,
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

          // Essential Services Carousel
          SizedBox(
            height: 120,
            child: Builder(
              builder: (context) {
                final services = [
                  {
                    'title': 'Informations',
                    'icon': 'assets/newessential/info.svg',
                    'color': const Color(0xFFFF5722),
                    'route': '/informations',
                  },
                  {
                    'title': 'Embassy',
                    'icon':
                        'assets/newessential/City-Hall--Streamline-Core-Gradient.svg',
                    'color': const Color(0xFF9C27B0),
                    'route': '/embassy',
                  },
                  {
                    'title': 'Article',
                    'icon':
                        'assets/newessential/Multiple-File-2--Streamline-Core-Gradient.svg',
                    'color': const Color(0xFF00BFA5),
                    'route': '/articles',
                  },
                  {
                    'title': 'Basic Goods',
                    'icon':
                        'assets/newessential/Shopping-Basket-2--Streamline-Core-Gradient.svg',
                    'color': const Color(0xFF448AFF),
                    'route': '/basicgoods',
                  },
                  {
                    'title': 'Community',
                    'icon':
                        'assets/newessential/User-Multiple-Group--Streamline-Core-Gradient.svg',
                    'color': const Color(0xFF4CAF50),
                    'route': '/community',
                  },
                ];
                return ListView.separated(
                  controller:
                      Get.find<DashboardController>().essentialScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: services.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = services[index];
                    return _buildEssentialServiceItem(
                      item['title'] as String,
                      item['icon'] as String,
                      item['color'] as Color,
                      () => Get.toNamed(item['route'] as String),
                    );
                  },
                );
              },
            ),
          ),

          // Community Feed Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'community_feed'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed('/community-feed'),
                  child: Text(
                    'view_all'.tr,
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
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: Text('no_posts_available'.tr)),
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
                final post = displayPosts[index];
                return CommunityPostCard(
                  post: post,
                  index: index,
                  controller: feedController,
                  isDashboard: true,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSehriIftarCompactCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.RAMADANCALANDER),
      child: Container(
        width: 120,
        height: 175,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFD4F3D8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Obx(() {
          RamadancalanderController? rController;
          try {
            rController = Get.find<RamadancalanderController>();
          } catch (e) {
            rController = Get.put(RamadancalanderController());
          }

          final data =
              rController?.todayRamadanData ??
              {
                'date': '18 Feb',
                'seheri': '04:55 AM',
                'iftar': '5:26 PM',
                'location': 'Beirut',
              };

          return Column(
            children: [
              // Date and Location Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.history, size: 8, color: Colors.black),
                        const SizedBox(width: 2),
                        Text(
                          data['date']!.split(' 2026')[0],
                          style: GoogleFonts.poppins(
                            fontSize: 7,
                            fontWeight: FontWeight.w500,
                          ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
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
                          Image.asset(
                            'assets/images/sheheri.png',
                            width: 22,
                            height: 22,
                          ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
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
                          Image.asset(
                            'assets/images/ifter.png',
                            width: 22,
                            height: 22,
                          ),
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
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF4FF),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Builder(
                builder: (context) {
                  if (imagePath.endsWith('.svg')) {
                    return SvgPicture.asset(
                      imagePath,
                      width: 38,
                      height: 38,
                      fit: BoxFit.contain,
                      placeholderBuilder: (BuildContext context) => const Icon(
                        Icons.grid_view_rounded,
                        color: Colors.grey,
                        size: 28,
                      ),
                    );
                  } else {
                    return Image.asset(
                      imagePath,
                      width: 38,
                      height: 38,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, color: Colors.grey, size: 28),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style:
                GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C2C2C),
                ).copyWith(
                  fontFamilyFallback: [GoogleFonts.hindSiliguri().fontFamily!],
                ),
          ),
        ],
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
        height: 170,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath.startsWith('http'))
              CachedNetworkImage(
                imageUrl: imagePath,
                height: iconSize,
                fit: BoxFit.contain,
                placeholder: (context, url) => SizedBox(
                  height: iconSize,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.broken_image,
                  size: iconSize,
                  color: Colors.grey,
                ),
              )
            else
              Image.asset(
                imagePath,
                height: iconSize,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_not_supported,
                  size: iconSize,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C2C2C),
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
                const Icon(
                  Icons.access_time,
                  size: 12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  footerText,
                  style:
                      GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                      ).copyWith(
                        fontFamilyFallback: [
                          GoogleFonts.hindSiliguri().fontFamily!,
                        ],
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
