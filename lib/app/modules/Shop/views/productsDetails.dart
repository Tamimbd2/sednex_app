import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late final Map<String, dynamic> product;

  @override
  void initState() {
    super.initState();
    product = Get.arguments as Map<String, dynamic>? ?? {};
  }

  @override
  Widget build(BuildContext context) {
    if (product.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }
    
    // Fallbacks for data to avoid null errors
    final List<String> images = (product['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [product['image'] ?? ''];
    final List<Color> colors = (product['colors'] as List<dynamic>?)?.cast<Color>() ?? [];
    final Map<String, dynamic> specs = (product['specifications'] as Map<String, dynamic>?) ?? {};
    final Map<String, dynamic> seller = (product['seller'] as Map<String, dynamic>?) ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: GoogleFonts.poppins(
            color: const Color(0xFF101727),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF101727), size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEFA5), // Yellow background from image
                    borderRadius: BorderRadius.circular(0), // Full width usually
                  ),
                   child: Image.network(
                     product['image'] ?? '',
                     fit: BoxFit.cover,
                     errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                   ),
                ),
                if (product['isSale'] == true && product['saleText'] == "New")
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC143C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'New',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
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
                        border: Border.all(color: const Color(0xFFDC143C), width: 1.5), // Selected style
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
            Text(
              product['category'] ?? 'Category',
              style: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product['name'] ?? 'Product Name',
              style: GoogleFonts.poppins(
                color: const Color(0xFF101727),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['price'] ?? '\$0.00',
              style: GoogleFonts.poppins(
                color: const Color(0xFFDC143C),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 24),

            // Colors
            if (colors.isNotEmpty) ...[
              Text(
                'Color',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF101727),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: colors.map((color) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
            
            // Description
            Text(
              'Description',
              style: GoogleFonts.poppins(
                color: const Color(0xFF101727),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product['description'] ?? 'Experience premium quality with this amazing product. Designed for comfort and durability, it fits perfectly into your lifestyle. Order now to enjoy exclusive features and benefits.',
              style: GoogleFonts.poppins(
                color: const Color(0xFF6B7280),
                fontSize: 12,
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Colors


            // Specifications
            if (specs.isNotEmpty) ...[
              Text(
                'Specifications',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF101727),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF6B7280), // Label color
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF101727), // Value color
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // WhatsApp action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC143C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, color: Colors.white), // Using standard icon as placeholder
                  const SizedBox(width: 8),
                  Text(
                    'Contact on WhatsApp',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
