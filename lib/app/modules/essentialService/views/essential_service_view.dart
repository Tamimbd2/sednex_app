import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/essential_service_controller.dart';

class EssentialServiceView extends GetView<EssentialServiceController> {
  const EssentialServiceView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Essential service',
          style: GoogleFonts.poppins(
            color: Colors.white,
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
              'assets/newessential/info.svg',
              const Color(0xFFFF5722),
              () => Get.toNamed('/informations'),
            ),
            _buildServiceCard(
              'Embassy',
              'assets/newessential/City-Hall--Streamline-Core-Gradient.svg',
              const Color(0xFF9C27B0),
              () => Get.toNamed('/embassy'),
            ),
            _buildServiceCard(
              'Article',
              'assets/newessential/Multiple-File-2--Streamline-Core-Gradient.svg',
              const Color(0xFF00BFA5),
              () => Get.toNamed('/articles'),
            ),
            _buildServiceCard(
              'Basic Goods',
              'assets/newessential/Shopping-Basket-2--Streamline-Core-Gradient.svg',
              const Color(0xFF448AFF),
              () => Get.toNamed('/basicgoods'),
            ),
            _buildServiceCard(
              'Community',
              'assets/newessential/User-Multiple-Group--Streamline-Core-Gradient.svg',
              const Color(0xFF4CAF50),
              () => Get.toNamed('/community'),
            ),
            _buildServiceCard(
              'Grocery Store',
              'assets/newessential/Store-1--Streamline-Core-Gradient.svg',
              const Color(0xFFFF9800),
              () => Get.toNamed('/general-section', arguments: {'slug': 'grocery-store', 'title': 'Grocery Store'}),
            ),
            _buildServiceCard(
              'Tourist spot',
              'assets/newessential/Beach--Streamline-Core-Gradient.svg',
              const Color(0xFF00BCD4),
              () => Get.toNamed('/tourist-spot'),
            ),
            _buildServiceCard(
              'Learn Arabic',
              'assets/newessential/Dictionary-Language-Book--Streamline-Core-Gradient.svg',
              const Color(0xFF795548),
              () => Get.toNamed('/learnarabic'),
            ),
            _buildServiceCard(
              'Restaurants',
              'assets/newessential/Fork-Knife--Streamline-Core-Gradient.svg',
              const Color(0xFFE91E63),
              () => Get.toNamed('/restaurents'),
            ),
            _buildServiceCard(
              'Hospitals',
              'assets/newessential/Ambulance--Streamline-Core-Gradient.svg',
              const Color(0xFFF44336),
              () => Get.toNamed('/hospitals'),
            ),
            _buildServiceCard(
              'Local Business',
              'assets/newessential/Briefcase-Dollar--Streamline-Core-Gradient.svg',
              const Color(0xFF607D8B),
              () => Get.toNamed('/general-section', arguments: {'slug': 'local-business', 'title': 'Local Business'}),
            ),
            _buildServiceCard(
              'Jewellery shop',
              'assets/newessential/Gift-2--Streamline-Core-Gradient.svg',
              const Color(0xFFFFC107),
              () => Get.toNamed('/general-section', arguments: {'slug': 'jewellery-shop', 'title': 'Jewellery shop'}),
            ),
            _buildServiceCard(
              'Clothing shop',
              'assets/newessential/Shopping-Bag-Hand-Bag-2--Streamline-Core-Gradient.svg',
              const Color(0xFF9C27B0),
              () => Get.toNamed('/general-section', arguments: {'slug': 'clothing-shop', 'title': 'Clothing shop'}),
            ),
            _buildServiceCard(
              'Organization',
              'assets/newessential/Business-Profession-Home-Office--Streamline-Core-Gradient.svg',
              const Color(0xFF3F51B5),
              () => Get.toNamed('/organization'),
            ),
            _buildServiceCard(
              'Sports team',
              'assets/newessential/Flash-3--Streamline-Core-Gradient.svg',
              const Color(0xFF8BC34A),
              () => Get.toNamed('/general-section', arguments: {'slug': 'sports-team', 'title': 'Sports team'}),
            ),
            _buildServiceCard(
              'Taxi Drivers',
              'assets/newessential/Car-Taxi-1--Streamline-Core-Gradient.svg',
              const Color(0xFFFFEB3B),
              () => Get.toNamed('/general-section', arguments: {'slug': 'texi-driver', 'title': 'Taxi Drivers'}),
            ),
            _buildServiceCard(
              'Businessman',
              'assets/newessential/Necktie--Streamline-Core-Gradient.svg',
              const Color(0xFF607D8B),
              () => Get.toNamed('/general-section', arguments: {'slug': 'businessman', 'title': 'Businessman'}),
            ),
            _buildServiceCard(
              'Influencer',
              'assets/newessential/Megaphone-2--Streamline-Core-Gradient.svg',
              const Color(0xFFE91E63),
              () => Get.toNamed('/general-section', arguments: {'slug': 'influencer', 'title': 'Influencer'}),
            ),
            _buildServiceCard(
              'Local Market',
              'assets/newessential/Shopping-Cart-1--Streamline-Core-Gradient.svg',
              const Color(0xFFFF5722),
              () => Get.toNamed('/general-section', arguments: {'slug': 'local-market', 'title': 'Local Market'}),
            ),
            _buildServiceCard(
              'Pharmacy',
              'assets/newessential/Tablet-Capsule--Streamline-Core-Gradient.svg',
              const Color(0xFF009688),
              () => Get.toNamed('/general-section', arguments: {'slug': 'pharmacy', 'title': 'Pharmacy'}),
            ),
            _buildServiceCard(
              'NGO',
              'assets/newessential/Decent-Work-And-Economic-Growth--Streamline-Core-Gradient.svg',
              const Color(0xFF4CAF50),
              () => Get.toNamed('/general-section', arguments: {'slug': 'ngo', 'title': 'NGO'}),
            ),
            _buildServiceCard(
              'Bus & Flight Booking',
              'assets/newessential/Bus--Streamline-Core-Gradient.svg',
              const Color(0xFF2196F3),
              () => Get.toNamed('/busflight'),
            ),
            _buildServiceCard(
              'Local Tour',
              'assets/newessential/Location-Pin-3--Streamline-Core-Gradient.svg',
              const Color(0xFF00BCD4),
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
    return _AdvancedServiceCard(
      label: label,
      imagePath: imagePath,
      color: backgroundColor,
      onTap: onTap,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Advanced Animated Service Card
// ═══════════════════════════════════════════════════════════════════════════════
class _AdvancedServiceCard extends StatefulWidget {
  final String label;
  final String imagePath;
  final Color color;
  final VoidCallback onTap;

  const _AdvancedServiceCard({
    required this.label,
    required this.imagePath,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AdvancedServiceCard> createState() => _AdvancedServiceCardState();
}

class _AdvancedServiceCardState extends State<_AdvancedServiceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    // slight stagger based on hashCode so each card enters a bit differently
    final delay = Duration(milliseconds: (widget.label.hashCode.abs() % 10) * 30);
    Future.delayed(delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.88 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeInOut,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icon Box ────────────────────────────────────────────────
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: _pressed ? 0.2 : 0.08),
                        blurRadius: _pressed ? 12 : 20,
                        spreadRadius: _pressed ? 0 : 2,
                        offset: Offset(0, _pressed ? 4 : 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Center(
                    child: Builder(
                      builder: (context) {
                        if (widget.imagePath.endsWith('.svg')) {
                          return SvgPicture.asset(
                            widget.imagePath,
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
                          // Fallback for png
                          return Image.asset(
                            widget.imagePath,
                            width: 38,
                            height: 38,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.grid_view_rounded,
                              color: Colors.grey,
                              size: 28,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                // ── Label ───────────────────────────────────────────────────
                Flexible(
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2C2C2C),
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


