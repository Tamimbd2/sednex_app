import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';
import '../controllers/shop_controller.dart';

class ShopView extends GetView<ShopController> {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF101727)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Shop',
          style: GoogleFonts.poppins(
            color: const Color(0xFFDC143C),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar (implied from context "Search products...")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Text(
                      'Search products...',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // #SpecialForYou Section
            _buildSectionHeader(title: '#SpecialForYou', actionText: 'See All'),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: controller.specialOffers.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final offer = controller.specialOffers[index];
                  return _buildSpecialOfferCard(offer);
                },
              ),
            ),
            
            // Pagination Dots (Simplified)
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(active: true),
                const SizedBox(width: 6),
                _buildDot(active: false),
                const SizedBox(width: 6),
                _buildDot(active: false),
              ],
            ),

            const SizedBox(height: 24),

            // Category Section
            _buildSectionHeader(
              title: 'Category',
              actionText: 'See All',
              onActionTap: () => Get.toNamed(Routes.ALL_CATEGORIES),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.spaceBetween,
                children: controller.categories.take(8).map((category) {
                  return GestureDetector(
                    onTap: () => Get.toNamed(Routes.ALL_PRODUCTS, arguments: category['name']),
                    child: _buildCategoryItem(category),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // All Products Section
            _buildSectionHeader(
              title: 'All Products',
              actionText: 'View All',
              onActionTap: () => Get.toNamed(Routes.ALL_PRODUCTS),
            ),
            const SizedBox(height: 16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.55, // Adjust based on card height/width ratio
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(controller.products[index]);
                },
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFF101727),
              fontSize: 16,
              fontWeight: FontWeight.w400, // User specified w400
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: GoogleFonts.poppins(
                color: const Color(0xFFDC143C),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOfferCard(Map<String, dynamic> offer) {
    return Container(
      width: 300, // Fixed width for horizontal scrolling cards
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: List<Color>.from(offer['gradientColors']),
        ),
      ),
      child: Stack(
        children: [
          // Background Image with Opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  offer['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Limited time!',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer['title'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // "Up to 40%" styled text
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Up to ',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      offer['subtitle'].replaceAll('Up to', '').replaceAll('%', '').trim(), // Extract number if possible, currently simplistic
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, height: 1.0),
                    ),
                     Text(
                      '%',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, height: 1.0),
                    ),
                  ],
                ),
                
                 const SizedBox(height: 4),
                 Text(
                   offer['description'],
                   style: GoogleFonts.poppins(
                     color: Colors.white.withValues(alpha: 0.7),
                     fontSize: 10,
                   ),
                 ),

                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC143C),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Claim',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool active}) {
    return Container(
      width: active ? 24 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFDC143C) : const Color(0xFFD1D5DC),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return SizedBox(
      width: 74, // Approximate width
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: category['color'], // Light background color
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              category['icon'],
              color: const Color(0xFF354152),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['name'],
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: const Color(0xFF354152),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PRODUCT_DETAILS, arguments: product),
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    color: const Color(0xFFF3F4F6),
                    child: Image.network(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
              ),
              // Sale Tag
              if (product['isSale'] == true)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product['saleColor'] ?? const Color(0xFFDC143C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product['saleText'],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              // Favorite Button
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
          
          // Details Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['category'] ?? '',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF697282),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF101727),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              product['price'], // e.g. $89.99
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFDC143C), // Red price
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (product['originalPrice'].isNotEmpty)
                            Text(
                              product['originalPrice'],
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF99A1AE),
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC143C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Details',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}

