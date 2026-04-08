import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/shop_controller.dart';
import '../../../core/constants/url.dart';

class ProductDetailsView extends GetView<ShopController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> product = Get.arguments is Map 
        ? Map<String, dynamic>.from(Get.arguments as Map) 
        : {};

    if (product.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }
    
    // Fallbacks for data to avoid null errors and format image URLs
    final List<String> rawImages = (product['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [product['image']?.toString() ?? ''];
    final List<String> images = rawImages.map((img) {
      if (img.isEmpty || img.startsWith('http')) return img;
      return '${AppUrl.baseUrl}$img';
    }).toList();
    
    // Safety check for specifications (API might send list or map)
    final Map<String, dynamic> specs = product['specifications'] is Map ? (product['specifications'] as Map<String, dynamic>) : {};
    
    // Safety check for seller (API might not include this or send different format)
    final Map<String, dynamic> seller = product['seller'] is Map ? (product['seller'] as Map<String, dynamic>) : {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E63FF),
                Color(0xFF4B83FF),
              ],
            ),
          ),
        ),
        title: Text(
          'Product Details',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          const SizedBox(width: 48), // Spacer to balance leading icon
        ],
      ),
      body: SafeArea(
        top: false, // AppBar handles top
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image
              Hero(
                tag: 'product_${product['id']}',
                child: Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          images.isNotEmpty ? images[0] : '',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.broken_image_rounded, size: 50, color: Colors.grey)),
                        ),
                      ),
                      if (product['isSale'] == true)
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E63FF),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Text(
                              product['saleText'] ?? 'SALE',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Thumbnails
              if (images.length > 1)
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCEFA5), // Consistent styling
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1E63FF), width: 1.5), // Selected style
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Image.network(
                          images[index],
                           fit: BoxFit.contain, // Maintain aspect
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 24),
              
              // Product Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product['category']?.toString().toUpperCase() ?? '',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF1E63FF),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product['name'] ?? 'Product Name',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF101727),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    product['price']?.toString() ?? '৳0',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF1E63FF),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Description
              Text(
                'Description',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF101727),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product['description'] ?? 'No description available.',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF64748B),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Specifications
              if (specs.isNotEmpty) ...[
                Text(
                  'Specifications',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF101727),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ...specs.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          entry.value,
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF101727),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],

              // Seller Info
              if (seller.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF9E1F42), // Burgundy color from image
                        child: Text(
                          seller['logo'] ?? 'S',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seller Information', 
                              style: GoogleFonts.poppins(
                                 color: const Color(0xFF6B7280),
                                 fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              seller['name'] ?? 'Store Name',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF101727),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                             Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: Color(0xFFFFAB00)),
                                const SizedBox(width: 4),
                                Text(
                                  '${seller['rating'] ?? 0.0}',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6B7280),
                                    fontSize: 12,
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
                
                const SizedBox(height: 100), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + MediaQuery.of(context).padding.bottom),
        child: Row(
          children: [
            // Cart Button
            Obx(() {
              final isLoved = (controller.products.firstWhereOrNull((p) => p['id'] == product['id'])?['isLoved'] ?? false);
              return GestureDetector(
                onTap: () => controller.toggleLove(product['id']),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isLoved
                        ? const Color(0xFF1E63FF).withValues(alpha: 0.1)
                        : const Color(0xFFF1F5FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isLoved 
                          ? const Color(0xFF1E63FF) 
                          : const Color(0xFF1E63FF).withValues(alpha: 0.2)
                    ),
                  ),
                  child: Icon(
                    isLoved ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
                    color: const Color(0xFF1E63FF),
                  ),
                ),
              );
            }),
            const SizedBox(width: 16),
            // WhatsApp Button
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E63FF), Color(0xFF4B83FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E63FF).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final String? url = product['whatsappUrl'];
                    if (url != null && url.isNotEmpty) {
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        Get.snackbar("Error", "Could not launch WhatsApp");
                      }
                    } else {
                      Get.snackbar("Notice", "WhatsApp contact not provided for this product");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'WhatsApp',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
    );
  }
}

