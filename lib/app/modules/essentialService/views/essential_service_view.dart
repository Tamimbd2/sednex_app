import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/essential_service_controller.dart';

class EssentialServiceView extends GetView<EssentialServiceController> {
  const EssentialServiceView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Essential service',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
          children: [
            _buildServiceCard(
              'Informations',
              'assets/essentialService/informations.png',
              const Color(0xFF4169E1),
              () => Get.toNamed('/informations'),
            ),
            _buildServiceCard(
              'Embassy',
              'assets/essentialService/embassy.png',
              const Color(0xFFDC143C),
              () => Get.toNamed('/embassy'),
            ),
            _buildServiceCard(
              'Article',
              'assets/essentialService/article.png',
              const Color(0xFFFFA500),
              () => Get.toNamed('/articles'),
            ),
            _buildServiceCard(
              'Basic Gods',
              'assets/essentialService/basicgoods.png',
              const Color(0xFF20B2AA),
              () => Get.toNamed('/basicgoods'),
            ),
            _buildServiceCard(
              'Community',
              'assets/essentialService/community.png',
              const Color(0xFF4169E1),
              () => Get.toNamed('/community'),
            ),
            _buildServiceCard(
              'Grocery Store',
              'assets/essentialService/store.png',
              const Color(0xFFDC143C),
              () => _showComingSoonDialog(context, 'Grocery Store'),
            ),
            _buildServiceCard(
              'Tourist spot',
              'assets/essentialService/touristspot.png',
              const Color(0xFFFFA500),
              () => Get.toNamed('/tourist-spot'),
            ),
            _buildServiceCard(
              'Learn Arabic',
              'assets/essentialService/learnarabic.png',
              const Color(0xFF4169E1),
              () => Get.toNamed('/learnarabic'),
            ),
            _buildServiceCard(
              'Restaurants',
              'assets/essentialService/restaurent.png',
              const Color(0xFF4169E1),
              () => Get.toNamed('/restaurents'),
            ),
            _buildServiceCard(
              'Hospitals',
              'assets/essentialService/hospital.png',
              const Color(0xFFDC143C),
              () => Get.toNamed('/hospitals'),
            ),
            _buildServiceCard(
              'Local Business',
              'assets/essentialService/Business.png',
              const Color(0xFFFFA500),
              () => _showComingSoonDialog(context, 'Local Business'),
            ),
            _buildServiceCard(
              'Jewellery shop',
              'assets/essentialService/Jeweller.png',
              const Color(0xFF20B2AA),
              () => _showComingSoonDialog(context, 'Jewellery shop'),
            ),
            _buildServiceCard(
              'Clothing shop',
              'assets/essentialService/clothshop.png',
              const Color(0xFF4169E1),
              () => _showComingSoonDialog(context, 'Clothing shop'),
            ),
            _buildServiceCard(
              'Organization',
              'assets/essentialService/Organization.png',
              const Color(0xFFDC143C),
              () => _showComingSoonDialog(context, 'Organization'),
            ),
            _buildServiceCard(
              'Sports team',
              'assets/essentialService/sports.png',
              const Color(0xFFFFA500),
              () => _showComingSoonDialog(context, 'Sports team'),
            ),
            _buildServiceCard(
              'Taxi Drivers',
              'assets/essentialService/texidriver.png',
              const Color(0xFF20B2AA),
              () => _showComingSoonDialog(context, 'Taxi Drivers'),
            ),
            _buildServiceCard(
              'Businessman',
              'assets/essentialService/businessman.png',
              const Color(0xFFFFA500),
              () => _showComingSoonDialog(context, 'Businessman'),
            ),
            _buildServiceCard(
              'Influencer',
              'assets/essentialService/Influencer.png',
              const Color(0xFFDC143C),
              () => _showComingSoonDialog(context, 'Influencer'),
            ),
            _buildServiceCard(
              'Local Market',
              'assets/essentialService/Local Market.png',
              const Color(0xFFFFA500),
              () => _showComingSoonDialog(context, 'Local Market'),
            ),
            _buildServiceCard(
              'Pharmacist',
              'assets/essentialService/Pharmacist.png',
              const Color(0xFF20B2AA),
              () => _showComingSoonDialog(context, 'Pharmacist'),
            ),

            _buildServiceCard(
              'NGO',
              'assets/essentialService/NGO.png',
              const Color(0xFFDC143C),
              () => _showComingSoonDialog(context, 'NGO'),
            ),
            _buildServiceCard(
              'Bus & Flight Booking',
              'assets/essentialService/Bus.png',
              const Color(0xFF20B2AA),
              () => Get.toNamed('/busflight'),
            ),
            _buildServiceCard(
              'Local Tour',
              'assets/essentialService/localTour.png',
              const Color(0xFF4169E1),
              () => Get.toNamed('/localtour'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    String label,
    String imagePath,
    Color backgroundColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String serviceName) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC143C).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    size: 50,
                    color: Color(0xFFDC143C),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Coming Soon!',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$serviceName feature is currently under development and will be available shortly.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC143C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Got it',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
