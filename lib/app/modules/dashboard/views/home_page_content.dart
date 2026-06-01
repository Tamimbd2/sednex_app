import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../communityFeed/controllers/community_feed_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../namaj/controllers/namaj_controller.dart';
import '../../ramadancalander/controllers/ramadancalander_controller.dart';
import '../../goldRate/controllers/gold_rate_controller.dart';

import '../../../routes/app_pages.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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
                    );
                  },
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
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 20,
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
                          iconSize: 50,
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

                  // 3. Dynamic Services (Filtering generic ramadan cards)
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
                            // Dynamically convert USD spot rate to BDT Vhori rate using current exchange rate
                            try {
                              final double usdPrice = double.tryParse(subtitle.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
                              // Retrieve the current rate from the controller if registered
                              double exchangeRate = 120.0;
                              try {
                                if (Get.isRegistered<GoldRateController>()) {
                                  exchangeRate = Get.find<GoldRateController>().usdToBdtRate.value;
                                }
                              } catch (_) {}
                              final double convertedVhoriRate = usdPrice * exchangeRate * 11.664;
                              final formatter = NumberFormat('#,##,###');
                              subtitle = '${formatter.format(convertedVhoriRate.round())}৳';
                            } catch (_) {
                              subtitle += '৳';
                            }
                          }
                          Color bgColor = isBkash
                              ? const Color(0xFFFCE4EC)
                              : (isGold
                                    ? const Color(0xFFFFF3E0)
                                    : const Color(0xFFE3F2FD));
                          Color subColor = isBkash
                              ? const Color(0xFFC2185B)
                              : (isGold
                                    ? const Color(0xFF1E63FF)
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
                            width: cardWidth,
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
          const SizedBox(height: 12),
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

          // Essential Services Grid (2 rows x 4 columns)
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
                  'articles'.tr,
                  'assets/Service Icon svg/Articels.svg',
                  const Color(0xFF00BFA5),
                  () => Get.toNamed('/articles'),
                  useColorFilter: true,
                  iconSize: 32,
                  useLightBlueBg: true,
                ),
                _buildEssentialServiceItem(
                  'shop'.tr,
                  'assets/Service Icon svg/Shopping.svg',
                  const Color(0xFF102A6B),
                  () => Get.toNamed('/shop'),
                  useColorFilter: true,
                  iconSize: 32,
                  useLightBlueBg: true,
                ),
                _buildEssentialServiceItem(
                  'bus_flight_booking'.tr,
                  'assets/Service Icon svg/Flight Booking.svg',
                  const Color(0xFF2196F3),
                  () => Get.toNamed('/busflight'),
                  useColorFilter: true,
                  iconSize: 32,
                  useLightBlueBg: true,
                ),
                _buildEssentialServiceItem(
                  'tourist_spots'.tr,
                  'assets/Service Icon svg/Tourist spots.svg',
                  const Color(0xFF00BCD4),
                  () => Get.toNamed('/tourist-spot'),
                  useColorFilter: true,
                  iconSize: 32,
                  useLightBlueBg: true,
                ),
                _buildEssentialServiceItem(
                  'learn_arabic'.tr,
                  'assets/Service Icon svg/Learn Arobic.svg',
                  const Color(0xFF795548),
                  () => Get.toNamed('/learnarabic'),
                  useColorFilter: true,
                  iconSize: 32,
                  useLightBlueBg: true,
                ),
                _buildEssentialServiceItem(
                  'local_tours'.tr,
                  'assets/Service Icon svg/Join Tour.svg',
                  const Color(0xFF00BCD4),
                  () => Get.toNamed('/localtour'),
                  useColorFilter: false,
                  iconSize: 32,
                  useLightBlueBg: true,
                ),
                _buildEssentialServiceItem(
                  'basic_goods'.tr,
                  'assets/Service Icon svg/Basic goods.svg',
                  const Color(0xFF448AFF),
                  () => Get.toNamed('/basicgoods'),
                  useColorFilter: false,
                  iconSize: 32,
                  useLightBlueBg: true,
                ),
                _buildEssentialServiceItem(
                  'users'.tr,
                  'assets/Service Icon svg/Users.svg',
                  const Color(0xFF4CAF50),
                  () => Get.toNamed('/community'),
                  useColorFilter: true,
                  iconSize: 32,
                  useLightBlueBg: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Explore Informations Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'explore_information'.tr,
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
                      fontWeight:
                          FontWeight.w600, // Make it slightly bolder too
                      color: const Color(0xFF1E63FF), // Vibrant blue
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Explore Informations Grid
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
                  'embassies'.tr,
                  'assets/newessential/City-Hall--Streamline-Core-Gradient.svg',
                  const Color(0xFF9C27B0),
                  () => Get.toNamed('/embassy'),
                ),
                _buildEssentialServiceItem(
                  'drivers'.tr,
                  'assets/newessential/Car-Taxi-1--Streamline-Core-Gradient.svg',
                  const Color(0xFFFFEB3B),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {'slug': 'texi-driver', 'title': 'drivers'.tr},
                  ),
                ),
                _buildEssentialServiceItem(
                  'sports_team'.tr,
                  'assets/newessential/Flash-3--Streamline-Core-Gradient.svg',
                  const Color(0xFF8BC34A),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'sports-team',
                      'title': 'sports_team'.tr,
                    },
                  ),
                ),
                _buildEssentialServiceItem(
                  'hospitals'.tr,
                  'assets/newessential/Ambulance--Streamline-Core-Gradient.svg',
                  const Color(0xFFF44336),
                  () => Get.toNamed('/hospitals'),
                ),

                _buildEssentialServiceItem(
                  'pharmacy'.tr,
                  'assets/newessential/Tablet-Capsule--Streamline-Core-Gradient.svg',
                  const Color(0xFF009688),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {'slug': 'pharmacy', 'title': 'pharmacy'.tr},
                  ),
                ),
                _buildEssentialServiceItem(
                  'grocery_store'.tr,
                  'assets/newessential/Store-1--Streamline-Core-Gradient.svg',
                  const Color(0xFFFF9800),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'grocery-store',
                      'title': 'grocery_store'.tr,
                    },
                  ),
                ),
                _buildEssentialServiceItem(
                  'jewellery_shop'.tr,
                  'assets/newessential/Gift-2--Streamline-Core-Gradient.svg',
                  const Color(0xFFFFC107),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'jewellery-shop',
                      'title': 'jewellery_shop'.tr,
                    },
                  ),
                ),
                _buildEssentialServiceItem(
                  'influencer'.tr,
                  'assets/newessential/Megaphone-2--Streamline-Core-Gradient.svg',
                  const Color(0xFFE91E63),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {'slug': 'influencer', 'title': 'influencer'.tr},
                  ),
                ),

                _buildEssentialServiceItem(
                  'organization'.tr,
                  'assets/newessential/Business-Profession-Home-Office--Streamline-Core-Gradient.svg',
                  const Color(0xFF3F51B5),
                  () => Get.toNamed('/organization'),
                ),
                _buildEssentialServiceItem(
                  'clothing_shop'.tr,
                  'assets/newessential/Shopping-Bag-Hand-Bag-2--Streamline-Core-Gradient.svg',
                  const Color(0xFF9C27B0),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'clothing-shop',
                      'title': 'clothing_shop'.tr,
                    },
                  ),
                ),
                _buildEssentialServiceItem(
                  'maker'.tr,
                  'assets/newessential/Shield-.svg',
                  const Color(0xFF1565C0),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {'slug': 'maker', 'title': 'maker'.tr},
                  ),
                ),
                _buildEssentialServiceItem(
                  'local_market'.tr,
                  'assets/newessential/Shopping-Cart-1--Streamline-Core-Gradient.svg',
                  const Color(0xFFFF5722),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'local-market',
                      'title': 'local_market'.tr,
                    },
                  ),
                ),

                _buildEssentialServiceItem(
                  'restaurants'.tr,
                  'assets/newessential/Fork-Knife--Streamline-Core-Gradient.svg',
                  const Color(0xFFE91E63),
                  () => Get.toNamed('/restaurents'),
                ),
                _buildEssentialServiceItem(
                  'local_business'.tr,
                  'assets/newessential/Briefcase-Dollar--Streamline-Core-Gradient.svg',
                  const Color.fromARGB(255, 3, 171, 255),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'local-business',
                      'title': 'local_business'.tr,
                    },
                  ),
                ),
                _buildEssentialServiceItem(
                  'businessman'.tr,
                  'assets/newessential/Necktie--Streamline-Core-Gradient.svg',
                  const Color(0xFF607D8B),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {
                      'slug': 'businessman',
                      'title': 'businessman'.tr,
                    },
                  ),
                ),
                _buildEssentialServiceItem(
                  'ngo'.tr,
                  'assets/newessential/Decent-Work-And-Economic-Growth--Streamline-Core-Gradient.svg',
                  const Color(0xFF4CAF50),
                  () => Get.toNamed(
                    '/general-section',
                    arguments: {'slug': 'ngo', 'title': 'ngo'.tr},
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
    bool useColorFilter = false,
    double iconSize = 38,
    bool useLightBlueBg = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: useLightBlueBg ? const Color(0xFFF5F9FF) : Colors.white,
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
                      colorFilter: useColorFilter
                          ? const ColorFilter.mode(
                              Color(0xFF5E90FF),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: const Color(0xFF2C2C2C),
              height: 1.2,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title.tr,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: const Color(0xFF424242),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.headingSmall.copyWith(
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
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.primary,
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
}
