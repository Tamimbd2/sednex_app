import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_text_styles.dart';
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
          'essential_services'.tr,
          style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
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
              'articles'.tr,
              'assets/Service Icon svg/Articels.svg',
              const Color(0xFF00BFA5),
              () => Get.toNamed('/articles'),
            ),
            _buildServiceCard(
              'shop'.tr,
              'assets/Service Icon svg/Shopping.svg',
              const Color(0xFF102A6B),
              () => Get.toNamed('/shop'),
            ),
            _buildServiceCard(
              'bus_flight_booking'.tr,
              'assets/Service Icon svg/Flight Booking.svg',
              const Color(0xFF2196F3),
              () => Get.toNamed('/busflight', arguments: {'type': 'flight'}),
            ),
            _buildServiceCard(
              'bus_service'.tr,
              'assets/newessential/Bus--Streamline-Core-Gradient.svg',
              const Color(0xFFFFD700),
              () => Get.toNamed('/busflight', arguments: {'type': 'bus'}),
            ),
            _buildServiceCard(
              'tourist_spots'.tr,
              'assets/Service Icon svg/Tourist spots.svg',
              const Color(0xFF00BCD4),
              () => Get.toNamed('/tourist-spot'),
            ),
            _buildServiceCard(
              'learn_arabic'.tr,
              'assets/Service Icon svg/Learn Arobic.svg',
              const Color(0xFF795548),
              () => Get.toNamed('/learnarabic'),
            ),
            _buildServiceCard(
              'local_tours'.tr,
              'assets/Service Icon svg/Join Tour.svg',
              const Color(0xFF00BCD4),
              () => Get.toNamed('/localtour'),
            ),
            _buildServiceCard(
              'basic_goods'.tr,
              'assets/Service Icon svg/Basic goods.svg',
              const Color(0xFF448AFF),
              () => Get.toNamed('/basicgoods'),
            ),
            _buildServiceCard(
              'users'.tr,
              'assets/Service Icon svg/Users.svg',
              const Color(0xFF4CAF50),
              () => Get.toNamed('/community'),
            ),
            _buildServiceCard(
              'restaurants'.tr,
              'assets/newessential/Fork-Knife--Streamline-Core-Gradient.svg',
              const Color(0xFFE91E63),
              () => Get.toNamed('/restaurents'),
            ),
            _buildServiceCard(
              'hospitals'.tr,
              'assets/newessential/Ambulance--Streamline-Core-Gradient.svg',
              const Color(0xFFF44336),
              () => Get.toNamed('/hospitals'),
            ),
            _buildServiceCard(
              'local_business'.tr,
              'assets/newessential/Briefcase-Dollar--Streamline-Core-Gradient.svg',
              const Color(0xFF607D8B),
              () => Get.toNamed(
                '/general-section',
                arguments: {
                  'slug': 'local-business',
                  'title': 'local_business'.tr,
                },
              ),
            ),
            _buildServiceCard(
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
            _buildServiceCard(
              'clothing_shop'.tr,
              'assets/newessential/Shopping-Bag-Hand-Bag-2--Streamline-Core-Gradient.svg',
              const Color(0xFF9C27B0),
              () => Get.toNamed(
                '/general-section',
                arguments: {'slug': 'clothing-shop', 'title': 'clothing_shop'.tr},
              ),
            ),
            _buildServiceCard(
              'organizations'.tr,
              'assets/newessential/Business-Profession-Home-Office--Streamline-Core-Gradient.svg',
              const Color(0xFF3F51B5),
              () => Get.toNamed('/organization'),
            ),
            _buildServiceCard(
              'sports_team'.tr,
              'assets/newessential/Flash-3--Streamline-Core-Gradient.svg',
              const Color(0xFF8BC34A),
              () => Get.toNamed(
                '/general-section',
                arguments: {'slug': 'sports-team', 'title': 'sports_team'.tr},
              ),
            ),
            _buildServiceCard(
              'drivers'.tr,
              'assets/newessential/Car-Taxi-1--Streamline-Core-Gradient.svg',
              const Color(0xFFFFEB3B),
              () => Get.toNamed(
                '/general-section',
                arguments: {'slug': 'texi-driver', 'title': 'drivers'.tr},
              ),
            ),
            _buildServiceCard(
              'businessman'.tr,
              'assets/newessential/Necktie--Streamline-Core-Gradient.svg',
              const Color(0xFF607D8B),
              () => Get.toNamed(
                '/general-section',
                arguments: {'slug': 'businessman', 'title': 'businessman'.tr},
              ),
            ),
            _buildServiceCard(
              'influencer'.tr,
              'assets/newessential/Megaphone-2--Streamline-Core-Gradient.svg',
              const Color(0xFFE91E63),
              () => Get.toNamed(
                '/general-section',
                arguments: {'slug': 'influencer', 'title': 'influencer'.tr},
              ),
            ),
            _buildServiceCard(
              'local_market'.tr,
              'assets/newessential/Shopping-Cart-1--Streamline-Core-Gradient.svg',
              const Color(0xFFFF5722),
              () => Get.toNamed(
                '/general-section',
                arguments: {'slug': 'local-market', 'title': 'local_market'.tr},
              ),
            ),
            _buildServiceCard(
              'pharmacy'.tr,
              'assets/newessential/Tablet-Capsule--Streamline-Core-Gradient.svg',
              const Color(0xFF009688),
              () => Get.toNamed(
                '/general-section',
                arguments: {'slug': 'pharmacy', 'title': 'pharmacy'.tr},
              ),
            ),
            _buildServiceCard(
              'ngo'.tr,
              'assets/newessential/Decent-Work-And-Economic-Growth--Streamline-Core-Gradient.svg',
              const Color(0xFF4CAF50),
              () => Get.toNamed(
                '/general-section',
                arguments: {'slug': 'ngo', 'title': 'ngo'.tr},
              ),
            ),

            _buildServiceCard(
              'local_tours'.tr,
              'assets/newessential/Location-Pin-3--Streamline-Core-Gradient.svg',
              const Color(0xFF00BCD4),
              () => Get.toNamed('/localtour'),
            ),
            _buildServiceCard(
              'maker'.tr,
              'assets/newessential/Shield-.svg',
              const Color(0xFF1565C0),
              () => Get.toNamed(
                '/general-section',
                arguments: {'slug': 'maker', 'title': 'maker'.tr},
              ),
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
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _scaleAnim = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    // slight stagger based on hashCode so each card enters a bit differently
    final delay = Duration(
      milliseconds: (widget.label.hashCode.abs() % 10) * 30,
    );
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
                        color: widget.color.withValues(
                          alpha: _pressed ? 0.2 : 0.08,
                        ),
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
                            placeholderBuilder: (BuildContext context) =>
                                const Icon(
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
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 12,
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
