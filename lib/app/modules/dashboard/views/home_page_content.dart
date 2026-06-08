import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../communityFeed/controllers/community_feed_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../namaj/controllers/namaj_controller.dart';
import '../../ramadancalander/controllers/ramadancalander_controller.dart';
import '../../bkashRate/controllers/bkash_rate_controller.dart';
import '../../goldRate/controllers/gold_rate_controller.dart';

import '../../../routes/app_pages.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/number_helper.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    Get.put(CommunityFeedController());

    final dashboardController = Get.find<DashboardController>();

    return SingleChildScrollView(
      controller: dashboardController.homeScrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
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
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return Stack(
                      children: [
                        PageView.builder(
                          controller: controller.bannerPageController,
                          onPageChanged: (index) =>
                              controller.currentBannerIndex.value = index,
                          itemCount: 10000,
                          itemBuilder: (context, index) {
                            final actualIndex = index % banners.length;
                            final banner = banners[actualIndex];
                            return AnimatedBuilder(
                              animation: controller.bannerPageController,
                              builder: (context, child) {
                                double page = 5000.0;
                                if (controller.bannerPageController.position.haveDimensions) {
                                  page = controller.bannerPageController.page ?? 5000.0;
                                }
                                final double delta = page - index;
                                final double opacity = (1.0 - delta.abs()).clamp(0.0, 1.0);
                                return Transform.translate(
                                  offset: Offset(delta * width, 0),
                                  child: Opacity(
                                    opacity: opacity,
                                    child: child,
                                  ),
                                );
                              },
                              child: GestureDetector(
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
                            child: AnimatedBuilder(
                              animation: controller.bannerPageController,
                              builder: (context, _) {
                                double page = 5000.0;
                                if (controller.bannerPageController.position.haveDimensions) {
                                  page = controller.bannerPageController.page ?? 5000.0;
                                }
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(banners.length, (index) {
                                    final double currentPage = page % banners.length;
                                    double diff = (currentPage - index).abs();
                                    if (diff > banners.length / 2) {
                                      diff = banners.length - diff;
                                    }
                                    final double activeFactor = (1.0 - diff).clamp(0.0, 1.0);
                                    final double width = 8.0 + (12.0 * activeFactor);
                                    final double opacity = 0.5 + (0.5 * activeFactor);

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: width,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: opacity),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            );
          }),

          // Daily Updates Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'daily_updates'.tr,
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Daily Updates Carousel
          Column(
            children: [
              SizedBox(
                height: 110,
                child: Obx(() {
                  final dController = Get.find<DashboardController>();
                  final services = dController.servicesList;
                  final screenWidth = MediaQuery.of(context).size.width;
                  // 32 for total horizontal padding (16*2), 24 for two separators (12*2)
                  final cardWidth = (screenWidth - 32 - 24) / 3;

                  // Construct static + dynamic items
                  final List<Widget> items = [];

                  // 1. Namaj Card
                  items.add(
                    SizedBox(
                      width: cardWidth,
                      child: Obx(() {
                        NamajController? nController;
                        try {
                          nController = Get.find<NamajController>();
                        } catch (e) {
                          nController = Get.put(NamajController());
                        }
                        final nextPrayer =
                            nController?.nextPrayerDisplay ??
                            {'name': 'Fazar', 'time': '05:45 AM'};
                        return _buildDailyUpdateCard(
                          title: nextPrayer['name']!,
                          subtitle: nextPrayer['name']!,
                          infoText: 'today'.tr,
                          pillText: nextPrayer['time']!.trNum,
                          imagePath: 'assets/Svg Icon/mosque-svgrepo-com.svg',
                          bgColor: const Color(0xFFE8F0FE),
                          pillColor: const Color(0xFF1E63FF),
                          isSvg: true,
                          iconColor: const Color(0xFF1E63FF),
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
                    items.add(_buildSehriIftarCompactCard(cardWidth));
                  }

                  // 3. Dynamic Services
                  items.addAll(
                    services
                        .where((service) {
                          String name = (service['name'] ?? '')
                              .toString()
                              .toLowerCase();
                          return !name.contains('ramadan');
                        })
                        .map((service) {
                          String name =
                              service['name']?.toString() ?? 'Service';
                          String image =
                              service['icon']?.toString() ??
                              service['image']?.toString() ??
                              '';
                          var rawRate =
                              service['rate'] ??
                              service['price'] ??
                              service['value'];
                          String subtitle = rawRate?.toString() ?? '0';

                          bool isBkash =
                              name.toLowerCase().contains('bkash') ||
                              image.toLowerCase().contains('bkash') ||
                              (name.toLowerCase() == 'gold rate' &&
                                  !image.toLowerCase().contains('gold'));
                          bool isGold =
                              !isBkash && name.toLowerCase().contains('gold');

                          if (isBkash) {
                            return SizedBox(
                              width: cardWidth,
                              child: Obx(() {
                                BkashRateController? bController;
                                try {
                                  bController = Get.find<BkashRateController>();
                                } catch (e) {
                                  bController = Get.put(BkashRateController());
                                }
                                
                                String bKashRate = subtitle;
                                if (bController != null && bController.exchangeRate.value > 0) {
                                  bKashRate = bController.exchangeRate.value.toStringAsFixed(0);
                                }
                                if (!bKashRate.endsWith('৳')) {
                                  bKashRate += '৳';
                                }

                                return _buildDailyUpdateCard(
                                  title: 'bKash',
                                  subtitle: 'bKash',
                                  infoText: 'bd rate',
                                  pillText: bKashRate.trNum,
                                  imagePath: 'assets/logo/bkash.png',
                                  bgColor: const Color(0xFFFCE4EC),
                                  pillColor: const Color(0xFFD12053),
                                  isSvg: false,
                                  onTap: () => Get.toNamed(Routes.BKASH_RATE),
                                );
                              }),
                            );
                          } else if (isGold) {
                            return SizedBox(
                              width: cardWidth,
                              child: Obx(() {
                                GoldRateController? gController;
                                try {
                                  gController = Get.find<GoldRateController>();
                                } catch (e) {
                                  gController = Get.put(GoldRateController());
                                }
                                
                                // Default fallback rate from services response
                                double usdPrice = 0.0;
                                try {
                                  usdPrice = double.tryParse(subtitle.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
                                } catch (_) {}
                                
                                // Convert fallback from USD to BDT
                                double fallbackBdtPrice = usdPrice * (gController?.usdToBdtRate.value ?? 120.0);
                                String goldPillText = "${fallbackBdtPrice.round()}৳";
                                
                                // Try to get live rate for 22 carat gold
                                if (gController != null && gController.rawRates.isNotEmpty) {
                                  final rate22 = gController.rawRates.firstWhereOrNull((r) => r['carat'] == '22');
                                  if (rate22 != null) {
                                    double price = rate22['rawPrice'] as double;
                                    String code = rate22['currency'] ?? 'usd';
                                    if (code == 'usd') {
                                      double bdtPrice = price * gController.usdToBdtRate.value;
                                      goldPillText = "${bdtPrice.round()}৳";
                                    } else {
                                      goldPillText = "${price.round()}৳";
                                    }
                                  }
                                }

                                return _buildDailyUpdateCard(
                                  title: 'Gold',
                                  subtitle: 'Gold',
                                  infoText: '22k Gr',
                                  pillText: goldPillText.trNum,
                                  imagePath: 'assets/Svg Icon/coin-svgrepo-com.svg',
                                  bgColor: const Color(0xFFFFF4E0),
                                  pillColor: const Color(0xFFE28B12),
                                  isSvg: true,
                                  iconColor: const Color(0xFFE28B12),
                                  onTap: () => Get.toNamed(Routes.GOLD_RATE),
                                );
                              }),
                            );
                          } else {
                            // Fallback card design
                            return SizedBox(
                              width: cardWidth,
                              child: _buildDailyUpdateCard(
                                title: name,
                                subtitle: name,
                                infoText: 'today',
                                pillText: subtitle,
                                imagePath: image.isNotEmpty ? image : 'assets/logo/logoicon.png',
                                bgColor: const Color(0xFFE3F2FD),
                                pillColor: const Color(0xFF1565C0),
                                isSvg: image.endsWith('.svg'),
                                onTap: () {},
                              ),
                            );
                          }
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
          const SizedBox(height: 12),
          // Quick Access Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'quick_access'.tr,
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Quick Access Grid (2x2)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildQuickAccessCard(
                  title: 'probashi_guide'.tr,
                  imagePath: 'assets/Svg Icon/book-2-svgrepo-com.svg',
                  cardColor: const Color(0xFF1E63FF),
                  onTap: () => Get.toNamed('/articles'),
                ),
                _buildQuickAccessCard(
                  title: 'learn_local_arabic'.tr,
                  imagePath: 'assets/Svg Icon/speaking-head-svgrepo-com.svg',
                  cardColor: const Color(0xFF00C853),
                  onTap: () => Get.toNamed('/learnarabic'),
                ),
                _buildQuickAccessCard(
                  title: 'daily_goods_prices'.tr,
                  imagePath: 'assets/Svg Icon/basket-svgrepo-com.svg',
                  cardColor: const Color(0xFF8B5CF6),
                  onTap: () => Get.toNamed('/basicgoods'),
                ),
                _buildQuickAccessCard(
                  title: 'users_directory'.tr,
                  imagePath: 'assets/Svg Icon/users-svgrepo-com.svg',
                  cardColor: const Color(0xFFFF9100),
                  onTap: () => Get.toNamed('/community'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Essential Services Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'essential_services'.tr,
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Essential Services Grid (2x2 horizontal cards)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildHorizontalEssentialCard(
                  title: 'flight_booking'.tr,
                  imagePath: 'assets/Service Icon svg/Flight Booking.svg',
                  themeColor: const Color(0xFF1E63FF),
                  bgColor: const Color(0xFFE8F0FE),
                  onTap: () => Get.toNamed('/busflight', arguments: {'type': 'flight'}),
                ),
                _buildHorizontalEssentialCard(
                  title: 'lebanon_tour'.tr,
                  imagePath: 'assets/Svg Icon/map-pin.svg',
                  themeColor: const Color(0xFF4CAF50),
                  bgColor: const Color(0xFFE8F5E9),
                  onTap: () => Get.toNamed('/localtour'),
                ),
                _buildHorizontalEssentialCard(
                  title: 'bus_booking'.tr,
                  imagePath: 'assets/Svg Icon/bus-svgrepo-com 2.svg',
                  themeColor: const Color(0xFF00ACC1),
                  bgColor: const Color(0xFFE0F7FA),
                  onTap: () => Get.toNamed('/busflight', arguments: {'type': 'bus'}),
                ),
                _buildHorizontalEssentialCard(
                  title: 'tourist_spots'.tr,
                  imagePath: 'assets/Svg Icon/eiffel-tower-svgrepo-com.svg',
                  themeColor: const Color(0xFFFFB300),
                  bgColor: const Color(0xFFFFF8E1),
                  onTap: () => Get.toNamed('/tourist-spot'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Jobs for You Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'jobs_for_you'.tr,
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/community-feed');
                    try {
                      final commController = Get.find<CommunityFeedController>();
                      commController.selectedFilter.value = "Job Posts";
                    } catch (_) {}
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'all_posts'.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFF1E63FF),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_circle_right_rounded,
                          color: Color(0xFF1E63FF),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Jobs Carousel
          SizedBox(
            height: 110,
            child: Obx(() {
              final dController = Get.find<DashboardController>();
              if (dController.isJobsLoading.value && dController.jobPostsList.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
                );
              }
              if (dController.jobPostsList.isEmpty) {
                return const SizedBox.shrink();
              }
              
              final jobPosts = dController.jobPostsList;
              
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: jobPosts.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index == jobPosts.length) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/community-feed');
                        try {
                          final commController = Get.find<CommunityFeedController>();
                          commController.selectedFilter.value = "Job Posts";
                        } catch (_) {}
                      },
                      child: Container(
                        width: 90,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4FE),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.more_horiz_rounded,
                            color: Color(0xFF1E63FF),
                            size: 36,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  final post = jobPosts[index];
                  final String name = post['name'] ?? 'Unknown';
                  final String content = post['content'] ?? '';
                  final String avatar = post['avatar'] ?? '';
                  
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/community-feed');
                      try {
                        final commController = Get.find<CommunityFeedController>();
                        commController.selectedFilter.value = "Job Posts";
                      } catch (_) {}
                    },
                    child: Container(
                      width: 270,
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: CachedNetworkImage(
                                imageUrl: avatar,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Icon(Icons.person, color: Colors.grey),
                                errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: const Color(0xFF2C2C2C),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Text(
                                    content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: 12,
                                      color: const Color(0xFF455A64),
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 24),
          // Store & Food Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Store & Food',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Store & Food Grid (2x2)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildHorizontalEssentialCard(
                  title: 'Restaurants and Cafes',
                  imagePath: 'assets/Svg Icon/restaurant-svgrepo-com.svg',
                  themeColor: const Color(0xFFEF5350),
                  bgColor: const Color(0xFFFFEBEE),
                  onTap: () => Get.toNamed('/restaurents'),
                ),
                _buildHorizontalEssentialCard(
                  title: 'Clothing Shops',
                  imagePath: 'assets/Svg Icon/tshirt.svg',
                  themeColor: const Color(0xFFAB47BC),
                  bgColor: const Color(0xFFF3E5F5),
                  onTap: () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'clothing-shop',
                      'title': 'clothing_shop'.tr,
                    },
                  ),
                ),
                _buildHorizontalEssentialCard(
                  title: 'Jewellery Shops',
                  imagePath: 'assets/Svg Icon/crown-svgrepo-com 2.svg',
                  themeColor: const Color(0xFFFFB300),
                  bgColor: const Color(0xFFFFF8E1),
                  onTap: () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'jewellery-shop',
                      'title': 'jewellery_shop'.tr,
                    },
                  ),
                ),
                _buildHorizontalEssentialCard(
                  title: 'Groceries Stores',
                  imagePath: 'assets/Svg Icon/basket-svgrepo-com 2.svg',
                  themeColor: const Color(0xFF26A69A),
                  bgColor: const Color(0xFFE0F2F1),
                  onTap: () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'grocery-store',
                      'title': 'grocery_store'.tr,
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () => Get.toNamed('/shop'),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E63FF), Color(0xFF4A80FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E63FF).withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative background curved patterns
                      Positioned(
                        left: -30,
                        top: -50,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        bottom: -70,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      // Main Content
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Text(
                                      'SHOP NOW',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: const Color(0xFF1E63FF),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Explore the best quality products from our shop.',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/Svg Icon/shop-2-svgrepo-com.svg',
                                  width: 28,
                                  height: 28,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF1E63FF),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          // Medical & Support Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Medical & Support',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Medical & Support Grid (4 items)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 0,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildEssentialServiceItem(
                  'Embassys',
                  'assets/Svg Icon/building-svgrepo-com 2.svg',
                  const Color(0xFFE0F7FA), // Soft cyan
                  () => Get.toNamed('/embassy'),
                  iconColor: const Color(0xFF009688), // Match green-cyan tone
                ),
                _buildEssentialServiceItem(
                  'Hospitals',
                  'assets/Svg Icon/hospital.svg',
                  const Color(0xFFFFEBEE), // Soft red
                  () => Get.toNamed('/hospitals'),
                  iconColor: const Color(0xFFEF5350), // Match red-pink tone
                ),
                _buildEssentialServiceItem(
                  'Lowers',
                  'assets/Svg Icon/lawyer-svgrepo-com.svg',
                  const Color(0xFFFFF3E0), // Soft orange/brown
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'sports-team',
                      'title': 'sports_team'.tr,
                    },
                  ),
                  iconColor: const Color(0xFFD84315), // Match orange-brown tone
                ),
                _buildEssentialServiceItem(
                  'NGO',
                  'assets/Svg Icon/building-ngo-svgrepo-com.svg',
                  const Color(0xFFE8F5E9), // Soft green
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {'slug': 'ngo', 'title': 'ngo'.tr},
                  ),
                  iconColor: const Color(0xFF2E7D32), // Match green tone
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Additional Info Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Additional Info',
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 20,
                    color: const Color(0xFF2C2C2C),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed('/informations'),
                  child: Text(
                    'view_all'.tr,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E63FF),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Additional Info Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildEssentialServiceItem(
                  'Companies',
                  'assets/Svg Icon/worker-svgrepo-com.svg',
                  const Color(0xFFE8F0FE), // Light blue
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {'slug': 'pharmacy', 'title': 'pharmacy'.tr},
                  ),
                  iconColor: const Color(0xFF1E63FF),
                ),
                _buildEssentialServiceItem(
                  'Mechanics',
                  'assets/Svg Icon/mechanic-tools-svgrepo-com.svg',
                  const Color(0xFFF3E5F5), // Light purple
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'clothing-shop',
                      'title': 'clothing_shop'.tr,
                    },
                  ),
                  iconColor: const Color(0xFF9C27B0),
                ),
                _buildEssentialServiceItem(
                  'Sports Teams',
                  'assets/Svg Icon/sports-basketball-svgrepo-com.svg',
                  const Color(0xFFFFF8E1), // Light amber
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'sports-team',
                      'title': 'sports_team'.tr,
                    },
                  ),
                  iconColor: const Color(0xFFE65100),
                ),
                _buildEssentialServiceItem(
                  'Influencers',
                  'assets/Svg Icon/video-play.svg',
                  const Color(0xFFFCE4EC), // Light pink
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {'slug': 'influencer', 'title': 'influencer'.tr},
                  ),
                  iconColor: const Color(0xFFE91E63),
                ),
                _buildEssentialServiceItem(
                  'Vehicles',
                  'assets/Svg Icon/vehicle-cab-svgrepo-com.svg',
                  const Color(0xFFFFEBEE), // Light red
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {'slug': 'texi-driver', 'title': 'drivers'.tr},
                  ),
                  iconColor: const Color(0xFFEF5350),
                ),
                _buildEssentialServiceItem(
                  'Local Market',
                  'assets/Svg Icon/market-place-svgrepo-com.svg',
                  const Color(0xFFE8F5E9), // Light green
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'local-market',
                      'title': 'local_market'.tr,
                    },
                  ),
                  iconColor: const Color(0xFF2E7D32),
                ),
                _buildEssentialServiceItem(
                  'Organizations',
                  'assets/Svg Icon/system-svgrepo-com.svg',
                  const Color(0xFFFFF3E0), // Light orange
                  () => Get.toNamed('/organization'),
                  iconColor: const Color(0xFFFF9800),
                ),
                // "More (...)" / All Category items card
                GestureDetector(
                  onTap: () => Get.toNamed('/informations'),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F9FF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.more_horiz_rounded,
                            color: Color(0xFF1E63FF),
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'More',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSehriIftarCompactCard(double cardWidth) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.RAMADANCALANDER),
      child: Container(
        width: cardWidth,
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
                          style: AppTextStyles.bodySmall.copyWith(
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
                            'seheri'.tr,
                            style: AppTextStyles.bodySmall.copyWith(
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
                        style: AppTextStyles.subHeadingLarge.copyWith(
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
                            'iftar'.tr,
                            style: AppTextStyles.bodySmall.copyWith(
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
                        style: AppTextStyles.subHeadingLarge.copyWith(
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
    VoidCallback onTap, {
    Color? iconColor,
    double iconSize = 38,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
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
                      width: iconSize,
                      height: iconSize,
                      fit: BoxFit.contain,
                      colorFilter: iconColor != null
                          ? ColorFilter.mode(
                              iconColor,
                              BlendMode.srcIn,
                            )
                          : null,
                      placeholderBuilder: (BuildContext context) => const Icon(
                        Icons.grid_view_rounded,
                        color: Colors.grey,
                        size: 28,
                      ),
                    );
                  } else {
                    return Image.asset(
                      imagePath,
                      width: iconSize,
                      height: iconSize,
                      fit: BoxFit.contain,
                      color: iconColor,
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
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              color: const Color(0xFF2C2C2C),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required String title,
    required String imagePath,
    required Color cardColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative background circles (top-right corner pattern)
              Positioned(
                right: -15,
                top: -15,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: -30,
                top: 15,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          imagePath,
                          width: 26,
                          height: 26,
                          colorFilter: ColorFilter.mode(cardColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalEssentialCard({
    required String title,
    String? subtitle,
    required String imagePath,
    required Color themeColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: themeColor.withValues(alpha: 0.1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(9),
              child: SvgPicture.asset(
                imagePath,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF2C2C2C),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.15,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFFE53935),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyUpdateCard({
    required String title,
    required String subtitle,
    required String infoText,
    required String pillText,
    required String imagePath,
    required Color bgColor,
    required Color pillColor,
    required bool isSvg,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isSvg)
                  SvgPicture.asset(
                    imagePath,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    colorFilter: iconColor != null
                        ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                        : null,
                  )
                else
                  Image.asset(
                    imagePath,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    infoText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headingSmall.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2C2C2C),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                color: pillColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                pillText,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
