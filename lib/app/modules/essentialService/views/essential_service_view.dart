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
              const Color(0xFF1976D2), // Info Blue
              () => Get.toNamed('/informations'),
            ),
            _buildServiceCard(
              'Embassy',
              'assets/essentialService/embassy.png',
              const Color(0xFF6A1B9A), // Official Purple
              () => Get.toNamed('/embassy'),
            ),
            _buildServiceCard(
              'Article',
              'assets/essentialService/article.png',
              const Color(0xFFFF6F00), // Amber - reading/knowledge
              () => Get.toNamed('/articles'),
            ),
            _buildServiceCard(
              'Basic Gods',
              'assets/essentialService/basicgoods.png',
              const Color(0xFF00897B), // Teal - daily essentials
              () => Get.toNamed('/basicgoods'),
            ),
            _buildServiceCard(
              'Community',
              'assets/essentialService/community.png',
              const Color(0xFF7B1FA2), // Purple - social/community
              () => Get.toNamed('/community'),
            ),
            _buildServiceCard(
              'Grocery Store',
              'assets/essentialService/store.png',
              const Color(0xFF388E3C), // Green - fresh grocery
              () => _showComingSoonDialog(context, 'Grocery Store'),
            ),
            _buildServiceCard(
              'Tourist spot',
              'assets/essentialService/touristspot.png',
              const Color(0xFF0097A7), // Cyan - scenic/travel
              () => Get.toNamed('/tourist-spot'),
            ),
            _buildServiceCard(
              'Learn Arabic',
              'assets/essentialService/learnarabic.png',
              const Color(0xFF1565C0), // Deep Blue - learning
              () => Get.toNamed('/learnarabic'),
            ),
            _buildServiceCard(
              'Restaurants',
              'assets/essentialService/restaurent.png',
              const Color(0xFFE53935), // Red-Orange - food/appetite
              () => Get.toNamed('/restaurents'),
            ),
            _buildServiceCard(
              'Hospitals',
              'assets/essentialService/hospital.png',
              const Color(0xFFC62828), // Medical Red
              () => Get.toNamed('/hospitals'),
            ),
            _buildServiceCard(
              'Local Business',
              'assets/essentialService/Business.png',
              const Color(0xFFF57C00), // Orange - commerce
              () => _showComingSoonDialog(context, 'Local Business'),
            ),
            _buildServiceCard(
              'Jewellery shop',
              'assets/essentialService/Jeweller.png',
              const Color(0xFFB8860B), // Dark Gold - jewellery
              () => _showComingSoonDialog(context, 'Jewellery shop'),
            ),
            _buildServiceCard(
              'Clothing shop',
              'assets/essentialService/clothshop.png',
              const Color(0xFFAD1457), // Deep Pink - fashion
              () => _showComingSoonDialog(context, 'Clothing shop'),
            ),
            _buildServiceCard(
              'Organization',
              'assets/essentialService/Organization.png',
              const Color(0xFF283593), // Deep Indigo - formal/official
              () => _showComingSoonDialog(context, 'Organization'),
            ),
            _buildServiceCard(
              'Sports team',
              'assets/essentialService/sports.png',
              const Color(0xFF2E7D32), // Dark Green - sports/energy
              () => _showComingSoonDialog(context, 'Sports team'),
            ),
            _buildServiceCard(
              'Taxi Drivers',
              'assets/essentialService/texidriver.png',
              const Color(0xFFF9A825), // Yellow - taxi
              () => _showComingSoonDialog(context, 'Taxi Drivers'),
            ),
            _buildServiceCard(
              'Businessman',
              'assets/essentialService/businessman.png',
              const Color(0xFF37474F), // Blue-Grey - professional
              () => _showComingSoonDialog(context, 'Businessman'),
            ),
            _buildServiceCard(
              'Influencer',
              'assets/essentialService/Influencer.png',
              const Color(0xFFE91E63), // Hot Pink - social media
              () => _showComingSoonDialog(context, 'Influencer'),
            ),
            _buildServiceCard(
              'Local Market',
              'assets/essentialService/Local Market.png',
              const Color(0xFFBF360C), // Deep Orange - market/bazaar
              () => _showComingSoonDialog(context, 'Local Market'),
            ),
            _buildServiceCard(
              'Pharmacist',
              'assets/essentialService/Pharmacist.png',
              const Color(0xFF00695C), // Dark Teal - pharmacy/medical
              () => _showComingSoonDialog(context, 'Pharmacist'),
            ),
            _buildServiceCard(
              'NGO',
              'assets/essentialService/NGO.png',
              const Color(0xFF1B5E20), // Dark Green - charity/social good
              () => _showComingSoonDialog(context, 'NGO'),
            ),
            _buildServiceCard(
              'Bus & Flight Booking',
              'assets/essentialService/Bus.png',
              const Color(0xFF0277BD), // Sky Blue - transportation/sky
              () => Get.toNamed('/busflight'),
            ),
            _buildServiceCard(
              'Local Tour',
              'assets/essentialService/localTour.png',
              const Color(0xFF00838F), // Cyan-Teal - tour/explore
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
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color,
                        widget.color.withOpacity(0.70),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(_pressed ? 0.6 : 0.35),
                        blurRadius: _pressed ? 16 : 10,
                        spreadRadius: _pressed ? 1 : 0,
                        offset: Offset(0, _pressed ? 2 : 5),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Top shine highlight
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.25),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Icon image
                      Image.asset(
                        widget.imagePath,
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.apps_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
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
