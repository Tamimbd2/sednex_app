import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/informations_controller.dart';

class InformationsView extends GetView<InformationsController> {
  const InformationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3575FF),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'Information',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                onChanged: (val) => controller.searchQuery.value = val,
                decoration: InputDecoration(
                  hintText: 'Search embassy, restaurant, phar...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[500], size: 22),
                  filled: true,
                  fillColor: Colors.grey[100], // Minimalist soft grey background
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none, // No borders initially for a clean look
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5), // Subtle focus border
                  ),
                ),
                style: GoogleFonts.inter(
                  color: const Color(0xFF2C2C2C),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: const Color(0xFF3575FF),
              ),
              const SizedBox(height: 12),

              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Information and service',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed('/essential-service'),
                    child: Text(
                      'View All',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF4169E1),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Service Cards Grid (2 rows x 4 columns = 8 cards)
              GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildServiceCard('Embassy', 'assets/newessential/City-Hall--Streamline-Core-Gradient.svg', const Color(0xFF9C27B0), () => Get.toNamed('/embassy')),
                  _buildServiceCard('Article', 'assets/newessential/Multiple-File-2--Streamline-Core-Gradient.svg', const Color(0xFF00BFA5), () => Get.toNamed('/articles')),
                  _buildServiceCard('Basic Goods', 'assets/newessential/Shopping-Basket-2--Streamline-Core-Gradient.svg', const Color(0xFF448AFF), () => Get.toNamed('/basicgoods')),
                  _buildServiceCard('Community', 'assets/newessential/User-Multiple-Group--Streamline-Core-Gradient.svg', const Color(0xFF4CAF50), () => Get.toNamed('/community')),
                  _buildServiceCard('Grocery Store', 'assets/newessential/Store-1--Streamline-Core-Gradient.svg', const Color(0xFFFF9800), () => _showComingSoonDialog(context, 'Grocery Store')),
                  _buildServiceCard('Tourist spot', 'assets/newessential/Beach--Streamline-Core-Gradient.svg', const Color(0xFF00BCD4), () => Get.toNamed('/tourist-spot')),
                  _buildServiceCard('Learn Arabic', 'assets/newessential/Dictionary-Language-Book--Streamline-Core-Gradient.svg', const Color(0xFF795548), () => Get.toNamed('/learnarabic')),
                  _buildServiceCard('Restaurants', 'assets/newessential/Fork-Knife--Streamline-Core-Gradient.svg', const Color(0xFFE91E63), () => Get.toNamed('/restaurents')),
                ],
              ),
              
              const SizedBox(height: 12),

              // "All" Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {}, // Can navigate to a full list if needed
                    child: Text(
                      'View All',
                      style: GoogleFonts.inter(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Mixed Services Grid (3 columns)
              GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.mixedServices.length,
                itemBuilder: (context, index) {
                  final service = controller.mixedServices[index];
                  return _buildMixedServiceCard(
                    service.label,
                    service.imagePath,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
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
                    color: const Color(0xFF1E63FF).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    size: 50,
                    color: Color(0xFF1E63FF),
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
                    backgroundColor: const Color(0xFF1E63FF),
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
  Widget _buildMixedServiceCard(String title, String iconPath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                iconPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),
        ],
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

