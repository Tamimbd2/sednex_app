import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controllers/informations_controller.dart';
import '../../embassy/views/embassydetails.dart';
import '../../hospitals/views/hospitaldetails.dart';
import '../../restaurents/views/restaurantdetails.dart';
import '../../organization/views/detailsorg.dart';

class InformationsView extends GetView<InformationsController> {
  const InformationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
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
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ).copyWith(
                    fontFamilyFallback: [
                      GoogleFonts.hindSiliguri().fontFamily!,
                    ],
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
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2C2C2C),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ).copyWith(
                  fontFamilyFallback: [
                    GoogleFonts.hindSiliguri().fontFamily!,
                  ],
                ),
                cursorColor: const Color(0xFF1E63FF),
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

              // Service Cards Grid (Dynamic based on search)
              Obx(() => GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.filteredServices.length,
                itemBuilder: (context, index) {
                  final service = controller.filteredServices[index];
                  return _buildServiceCard(
                    service.label,
                    service.imagePath,
                    service.backgroundColor,
                    () {
                      if (service.route != null) {
                        Get.toNamed(service.route!);
                      } else {
                        _showComingSoonDialog(context, service.label);
                      }
                    },
                  );
                },
              )),
              
              const SizedBox(height: 12),

              // "All" Section Header
              Text(
                'All',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ).copyWith(
                  fontFamilyFallback: [
                    GoogleFonts.hindSiliguri().fontFamily!,
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Mixed Live Cards Grid (3 columns × max 2 rows)
              Obx(() {
                if (controller.isLoadingMixed.value &&
                    controller.mixedCards.isEmpty) {
                  return const SizedBox(
                    height: 160,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1E63FF),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
                if (controller.mixedCards.isEmpty) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: Text('No data available'),
                    ),
                  );
                }
                final cards = controller.previewCards;
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return _buildLiveCard(cards[index], index);
                  },
                );
              }),
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
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ).copyWith(
                  fontFamilyFallback: [
                    GoogleFonts.hindSiliguri().fontFamily!,
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$serviceName feature is currently under development and will be available shortly.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ).copyWith(
                  fontFamilyFallback: [
                    GoogleFonts.hindSiliguri().fontFamily!,
                  ],
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
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ).copyWith(
                      fontFamilyFallback: [
                        GoogleFonts.hindSiliguri().fontFamily!,
                      ],
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
  Widget _buildLiveCard(MixedCard card, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + index * 60),
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - v)),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTap: () => _navigateToDetails(card),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                width: 52,
                height: 52,
                child: card.image.isNotEmpty
                    ? Image.network(
                        card.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          _typeIcon(card.type),
                          size: 32,
                          color: _typeColor(card.type).withValues(alpha: 0.4),
                        ),
                      )
                    : Icon(
                        _typeIcon(card.type),
                        size: 32,
                        color: _typeColor(card.type).withValues(alpha: 0.4),
                      ),
              ),
              const SizedBox(height: 8),
              // Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  card.name,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                    height: 1.3,
                  ).copyWith(
                    fontFamilyFallback: [
                      GoogleFonts.hindSiliguri().fontFamily!,
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(MixedCard card) {
    final args = {
      'id': card.id,
      'name': card.name,
      'logoPath': card.image,
    };
    switch (card.type) {
      case 'embassy':
        Get.to(() => const EmbassyDetailsView(), arguments: args);
        break;
      case 'hospitals':
        Get.to(() => const HospitalDetailsView(), arguments: args);
        break;
      case 'restaurents':
        Get.to(() => const RestaurantDetailsView(), arguments: args);
        break;
      case 'organization':
        Get.to(() => const OrganizationDetailsView(), arguments: args);
        break;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'embassy': return const Color(0xFF9C27B0);
      case 'hospitals': return const Color(0xFFF44336);
      case 'restaurents': return const Color(0xFFE91E63);
      case 'organization': return const Color(0xFF3F51B5);
      default: return const Color(0xFF1E63FF);
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'embassy': return Icons.account_balance_rounded;
      case 'hospitals': return Icons.local_hospital_rounded;
      case 'restaurents': return Icons.restaurant_rounded;
      case 'organization': return Icons.business_rounded;
      default: return Icons.category_rounded;
    }
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
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2C2C2C),
                      height: 1.25,
                    ).copyWith(
                      fontFamilyFallback: [
                        GoogleFonts.hindSiliguri().fontFamily!,
                      ],
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

