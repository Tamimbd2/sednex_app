import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/url.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../profile/views/profile_view.dart';
import '../../Shop/views/shop_view.dart';
import '../../notifications/controllers/notifications_controller.dart';
import 'home_page_content.dart';
import '../../communityFeed/widgets/community_post_card.dart';

// Detail View Imports for Search Navigation
import '../../articles/views/articledetails.dart';
import '../../hospitals/views/hospitaldetails.dart';
import '../../restaurents/views/restaurantdetails.dart';
import '../../organization/views/detailsorg.dart';
import '../../embassy/views/embassydetails.dart';
import '../../localtour/views/toursdetails.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top + 60),
        child: Obx(() {
          // Show header consistently across all tabs
          final statusBarHeight = MediaQuery.of(context).padding.top;

          return Container(
            height: statusBarHeight + 60,
            padding: EdgeInsets.only(top: statusBarHeight),
            decoration: BoxDecoration(
              color: const Color(0xFF1E63FF),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E63FF).withValues(alpha: 0.30),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Logo & Dynamic Title
                  Expanded(
                    child: Row(
                      mainAxisAlignment:
                          (controller.currentIndex.value == 1 ||
                              controller.currentIndex.value == 2)
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: [
                        if (controller.currentIndex.value != 1 &&
                            controller.currentIndex.value != 2)
                          Image.asset(
                            'assets/logo/Sednex Website Logo Eng@3x.png',
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        if (controller.currentIndex.value == 1 ||
                            controller.currentIndex.value == 2)
                          Text(
                            controller.currentIndex.value == 1
                                ? 'search'.tr
                                : 'shop'.tr,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (controller.currentIndex.value != 1 &&
                            controller.currentIndex.value != 2 &&
                            controller.currentIndex.value != 3 &&
                            (Get.locale?.languageCode != 'en' ||
                                controller.currentIndex.value != 0)) ...[
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 20,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _getAppBarTitle(controller.currentIndex.value),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (controller.currentIndex.value != 1 &&
                      controller.currentIndex.value != 2) ...[
                    // Notification Icon with Badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.0),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Get.find<NotificationsController>()
                                  .markAllAsRead();
                              Get.toNamed(Routes.NOTIFICATIONS);
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/Icon.svg',
                              width: 26,
                              height: 28,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        Obx(() {
                          final nController =
                              Get.find<NotificationsController>();
                          final unreadCount = nController.unreadCount;
                          if (unreadCount == 0) return const SizedBox.shrink();

                          return Positioned(
                            right: 5,
                            top: 5,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.crimson,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 9
                                      ? '9+'
                                      : unreadCount.toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Profile Picture
                    GestureDetector(
                      onTap: () => controller.changePage(3),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: controller.currentIndex.value == 3
                                ? AppColors.crimson
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Obx(() {
                          final imgUrl = controller.userProfileImage.value;
                          return CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[100],
                            backgroundImage: imgUrl != null
                                ? CachedNetworkImageProvider(imgUrl)
                                : null,
                            child: imgUrl == null
                                ? const Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Color(0xFF9CA3AF),
                                  )
                                : null,
                          );
                        }),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
      body: Obx(() => _getPage(controller.currentIndex.value)),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'home'.tr;
      case 1:
        return 'search'.tr;
      case 2:
        return 'shop'.tr;
      case 3:
        return 'profile'.tr;
      default:
        return 'home'.tr;
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildSearchPage();
      case 2:
        return _buildShopPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return const HomePageContent();
  }

  Widget _buildSearchPage() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (val) => controller.searchQuery.value = val,
              decoration: InputDecoration(
                hintText: '${'search'.tr}...',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey[500],
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF1E63FF),
                  size: 22,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
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
              style: GoogleFonts.inter(
                color: const Color(0xFF2C2C2C),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: const Color(0xFF1E63FF),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.searchQuery.isEmpty) {
                return _buildSearchPlaceholder();
              }

              if (controller.isSearchLoading.value) {
                return _buildSearchSkeleton();
              }

              if (controller.searchResults.isEmpty) {
                return _buildNoResultsState();
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final section = controller.searchResults.keys.elementAt(
                    index,
                  );
                  final items = controller.searchResults[section]!;
                  return _buildSearchSection(section, items);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E63FF).withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 48,
              color: Color(0xFF1E63FF),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'search_anything'.tr,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find posts, products, articles and more',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'no_results_found'.tr,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E63FF),
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                '${items.length} items',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length > 5 ? 5 : items.length,
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: Colors.grey[100], indent: 16),
          itemBuilder: (context, index) {
            final item = items[index];

            // Special handling for Community Posts to show the full card
            if (title == 'Community Posts') {
              // Map the item into the format expected by CommunityPostCard if needed
              // The search result already contains the correct fields from _searchSection

              // Map author name to post structure if it's missing in search data
              final Map<String, dynamic> mappedPost = {
                ...Map<String, dynamic>.from(item),
                'avatar': item['author'] is Map
                    ? item['author']['profileImage'] ??
                          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(item['author']['name'] ?? 'U')}'
                    : item['avatar'] ?? 'https://ui-avatars.com/api/?name=U',
                'name': item['author'] is Map
                    ? item['author']['name']
                    : item['name'] ?? 'Unknown',
                'time': item['createdAt'] != null
                    ? _timeAgo(item['createdAt'])
                    : '',
                'content': item['description'] ?? item['content'] ?? '',
                'likes': item['loveCount'] ?? 0,
                'comments': item['commentsCount'] ?? 0,
                'isLiked': item['isLiked'] ?? false,
              };

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: CommunityPostCard(
                  post: mappedPost,
                  index: index,
                  controller: controller,
                  isDashboard: true,
                  showFooter: false,
                ),
              );
            }

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildItemImage(item),
              ),
              title: Text(
                item['title'] ??
                    item['name'] ??
                    (item['author'] is Map ? item['author']['name'] : null) ??
                    'No Title',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                item['description'] ??
                    item['content'] ??
                    item['category'] ??
                    '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: Colors.grey,
              ),
              onTap: () {
                _navigateToDetail(title, item);
              },
            );
          },
        ),
        if (items.length > 5)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: TextButton(
              onPressed: () => _navigateToListView(title),
              child: Text(
                'View all $title',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF1E63FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Container(height: 8, color: Colors.grey[50]),
      ],
    );
  }

  void _navigateToDetail(String section, dynamic item) {
    if (item is! Map) return;

    switch (section) {
      case 'Articles':
        Get.to(
          () => const ArticleDetailsView(),
          arguments: {
            'title': item['title'],
            'description': item['description'],
            'imageUrl': item['image'] ?? item['imageUrl'],
            'date': item['createdAt'] != null
                ? DateTime.parse(item['createdAt'])
                : DateTime.now(),
            'fullContent': item['fullContent'] ?? [],
            'category': item['category'] ?? 'General',
            'authorName': item['author'] is Map
                ? item['author']['name']
                : 'Admin',
          },
        );
        break;
      case 'Products':
        // Product details expects the full product map as arg
        Get.toNamed(Routes.PRODUCT_DETAILS, arguments: item);
        break;
      case 'Hospitals':
        Get.to(
          () => const HospitalDetailsView(),
          arguments: {
            'id': item['_id'],
            'name': item['name'],
            'logoPath': item['image'],
          },
        );
        break;
      case 'Restaurants':
        Get.to(
          () => const RestaurantDetailsView(),
          arguments: {
            'id': item['_id'],
            'name': item['name'],
            'logoPath': item['image'],
          },
        );
        break;
      case 'Organizations':
        Get.to(
          () => const OrganizationDetailsView(),
          arguments: {
            'id': item['_id'],
            'name': item['name'],
            'logoPath': item['image'],
          },
        );
        break;
      case 'Embassies':
        Get.to(
          () => const EmbassyDetailsView(),
          arguments: {
            'id': item['_id'],
            'name': item['name'],
            'logoPath': item['image'],
          },
        );
        break;
      case 'Sednex Travel':
        Get.to(
          () => const LocalTourDetailsView(),
          arguments: {
            'title': item['title'],
            'image': item['image'],
            'locationDetails': item['locationDetails'] ?? '',
            'includedWithTickets': List<String>.from(
              item['includedWithTickets'] ?? [],
            ),
            'info': {
              'date': item['info']?['date'] ?? item['date'] ?? 'N/A',
              'distance': item['info']?['distance'] ?? 'N/A',
              'duration': item['info']?['duration'] ?? 'N/A',
              'ticketPrice':
                  item['info']?['ticketPrice'] ?? item['ticketPrice'] ?? '0',
              'ticketPriceTag':
                  item['info']?['ticketPriceTag'] ??
                  item['ticketPriceTag'] ??
                  '',
              'begins': item['info']?['begins'] ?? 'N/A',
              'returnTime': item['info']?['returnTime'] ?? 'N/A',
            },
          },
        );
        break;
      case 'Services':
        // Navigate to full view for specific service
        Get.toNamed(Routes.ESSENTIAL_SERVICE);
        break;
    }
  }

  void _navigateToListView(String section) {
    switch (section) {
      case 'Articles':
        Get.toNamed(Routes.ARTICLES);
        break;
      case 'Products':
        Get.toNamed(Routes.SHOP);
        break;
      case 'Community Posts':
        Get.toNamed(Routes.COMMUNITY_FEED);
        break;
      case 'Hospitals':
        Get.toNamed(Routes.HOSPITALS);
        break;
      case 'Restaurants':
        Get.toNamed(Routes.RESTAURENTS);
        break;
      case 'Organizations':
        Get.toNamed(Routes.ORGANIZATION);
        break;
      case 'Embassies':
        Get.toNamed(Routes.EMBASSY);
        break;
      case 'Sednex Travel':
        Get.toNamed(Routes.LOCALTOUR);
        break;
      case 'Services':
        Get.toNamed(Routes.ESSENTIAL_SERVICE);
        break;
    }
  }

  String _timeAgo(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      return '${(difference.inDays / 7).floor()}w ago';
    } catch (e) {
      return '';
    }
  }

  Widget _buildItemImage(dynamic item) {
    if (item is! Map) return _buildPlaceholderIcon();

    String? imageUrl;
    if (item['image'] != null && item['image'].toString().isNotEmpty) {
      imageUrl = item['image'].toString();
    } else if (item['imageUrl'] != null &&
        item['imageUrl'].toString().isNotEmpty) {
      imageUrl = item['imageUrl'].toString();
    } else if (item['images'] is List && (item['images'] as List).isNotEmpty) {
      imageUrl = item['images'][0].toString();
    } else if (item['icon'] != null && item['icon'].toString().isNotEmpty) {
      imageUrl = item['icon'].toString();
    } else if (item['logoPath'] != null &&
        item['logoPath'].toString().isNotEmpty) {
      imageUrl = item['logoPath'].toString();
    }

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholderIcon();
    }

    // Ensure URL is absolute
    if (!imageUrl.startsWith('http')) {
      imageUrl = '${AppUrl.baseUrl}$imageUrl';
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => _buildPlaceholderIcon(),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      width: 48,
      height: 48,
      color: Colors.grey[100],
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 20,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildShopPage() {
    return const ShopContent();
  }

  Widget _buildProfilePage() {
    return ProfileView();
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 15,
              offset: const Offset(
                0,
                -5,
              ), // Negative Y for bottom bar to show shadow upwards
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  iconPath: 'assets/nav/home.svg',
                  index: 0,
                  isActive: controller.currentIndex.value == 0,
                ),
                _buildNavItem(
                  iconPath: 'assets/nav/search.svg',
                  index: 1,
                  isActive: controller.currentIndex.value == 1,
                ),
                // Center + button
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.CREATEPOST),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.crimson,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, size: 28, color: Colors.white),
                  ),
                ),
                _buildNavItem(
                  iconPath: 'assets/profile/shop.svg', // Moved Shop to nav
                  index: 2,
                  isActive: controller.currentIndex.value == 2,
                ),
                _buildNavItem(
                  iconPath: 'assets/nav/profile.svg',
                  index: 3,
                  isActive: controller.currentIndex.value == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isActive ? const Color(0xFF1E63FF) : const Color(0xFF8F95A1),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[50]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(width: 150, height: 10, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
