import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sednexapp/app/core/constants/url.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/embassy_controller.dart';
import '../../../core/theme/app_colors.dart';

// ── Font Helper ──────────────────────────────────────────────────
TextStyle _getStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
  String? text,
  double? height,
  double? letterSpacing,
}) {
  return AppTextStyles.bodyMedium.copyWith(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

class EmbassyDetailsView extends StatefulWidget {
  const EmbassyDetailsView({super.key});

  @override
  State<EmbassyDetailsView> createState() => _EmbassyDetailsViewState();
}

class _EmbassyDetailsViewState extends State<EmbassyDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  int _selectedTabIndex = 0;
  bool _isLoading = true;
  String _name = '';
  String _imageUrl = '';
  String _coverPhoto = '';
  String _category = '';
  String _about = '';
  String _phone = '';
  String _email = '';
  String _website = '';
  String _address = '';
  String _mapUrl = '';
  String _direction = '';
  List<String> _services = [];
  List<String> _offDays = [];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchDetails());
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDetails() async {
    final args = Get.arguments is Map ? Map<String, dynamic>.from(Get.arguments as Map) : <String, dynamic>{};
    final Embassy? embassy = args['embassy'];

    // Support both: Embassy object (from embassy list) OR plain id/name/logoPath (from informations)
    final String id = embassy?.id ?? args['id'] ?? '';
    final String fallbackName = embassy?.name ?? args['name'] ?? '';
    final String fallbackImage = embassy?.icon ?? args['logoPath'] ?? '';
    final String fallbackCategory = embassy?.category ?? 'Embassy';

    // Set whatever we already have immediately
    setState(() {
      _name = fallbackName;
      _imageUrl = fallbackImage;
      _category = fallbackCategory;
      if (embassy != null) {
        _about = embassy.about;
        _phone = embassy.contact.phone;
        _email = embassy.contact.email;
        _website = embassy.contact.website;
        _address = embassy.contact.address;
        _services = embassy.services;
        _offDays = embassy.offDays;
      }
    });

    if (id.isEmpty) {
      setState(() => _isLoading = false);
      _animCtrl.forward();
      return;
    }

    try {
      final connect = GetConnect();
      final box = GetStorage();
      final token = box.read('token');
      final response = await connect.get(
        '${AppUrl.baseUrl}api/sections/embassy/items/$id/details',
        headers: {
          'Authorization':
              'Bearer ${token ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OWE2NDc4NGFiMjQ3YTI0NTc2MGIxOGIiLCJlbWFpbCI6IlNha2liQHNlZG5leC5jb20iLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3NzQ4NzkwNzUsImV4cCI6MTc3NTQ4Mzg3NX0.SYIpSj3uqab2J8EciPMW0nmb77xe-ld0NHruVyU1Ojs"}',
        },
      );
      if (!response.status.hasError) {
        var body = response.body;
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (_) {}
        }
        final itemData = body['item'] ?? {};
        final List detailsList = body['details'] ?? [];
        // Pick the most complete detail (one with contact/about), not just [0]
        final detail = detailsList.isNotEmpty
            ? detailsList.firstWhere(
                (d) => d['contact'] != null || d['about'] != null,
                orElse: () => detailsList[0],
              )
            : {};
        final contact = detail['contact'] ?? {};
        final location = detail['location'] ?? {};
        final about = detail['about'] ?? {};
        final List offSchedules = detail['offDaySchedules'] ?? [];

        // Find coverPhoto: check root, then item, then details list
        String coverPhoto = body['coverPhoto']?.toString() ?? 
                           itemData['coverPhoto']?.toString() ?? '';
        
        if (coverPhoto.isEmpty) {
          for (final d in detailsList) {
            if (d['coverPhoto'] != null && d['coverPhoto'].toString().isNotEmpty) {
              coverPhoto = d['coverPhoto'].toString();
              break;
            }
          }
        }

        // Final fallback: use item image if cover is still empty
        if (coverPhoto.isEmpty) {
          coverPhoto = itemData['image'] ?? itemData['icon'] ?? '';
        }

        setState(() {
          _name = itemData['name'] ?? fallbackName;
          _imageUrl = itemData['image'] ?? itemData['icon'] ?? fallbackImage;
          _coverPhoto = coverPhoto;
          _category = itemData['category'] ?? fallbackCategory;
          _about = about['description'] ?? _about;
          _phone = contact['mobile'] ?? contact['phone'] ?? _phone;
          _email = contact['email'] ?? _email;
          _website = contact['website'] ?? _website;
          _address = location['address'] ?? _address;
          _direction = contact['direction'] ?? _direction;
          _mapUrl = location['mapUrl'] ?? _mapUrl;
          _services = List<String>.from(about['services'] ?? _services);
          
          // Enhanced parsing for offDays (handles simple strings and nested JSON strings)
          final List<String> days = [];
          for (var e in offSchedules) {
            String d = e['day']?.toString() ?? '';
            if (d.startsWith('[') && d.endsWith(']')) {
              try {
                final List nested = jsonDecode(d);
                for (var n in nested) {
                  if (n is Map && n['day'] != null) {
                    days.add(n['day'].toString());
                  }
                }
                continue;
              } catch (_) {}
            }
            if (d.isNotEmpty) days.add(d);
          }
          _offDays = days.isEmpty ? _offDays : days;
        });
      }
    } catch (e) {
      debugPrint('Embassy detail error: $e');
    } finally {
      setState(() => _isLoading = false);
      _animCtrl.forward();
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Text(
          _name.isEmpty ? 'embassy_details'.tr : _name,
          style: _getStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: _name,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          )
        : FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _premiumHeader(),
                    const SizedBox(height: 20),
                    _tabCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  // ── Premium Header ──────────────────────────────────────────────
  Widget _premiumHeader() {
    final hasCover = _coverPhoto.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover Photo / Top Hero Section
        Stack(
          children: [
            Container(
              height: 240,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE2E8F0),
              ),
              child: hasCover
                  ? Image.network(
                      _coverPhoto,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _coverFallback(),
                    )
                  : _coverFallback(),
            ),
            // Gradient Overlay for better text readability and depth
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.1),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_name.isNotEmpty)
                Text(
                  _name,
                  style: _getStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                    text: _name,
                  ),
                ),
              if (_category.isNotEmpty || _name.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _category.isEmpty ? 'embassy'.tr : _category.toUpperCase(),
                    style: _getStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 1.0,
                      text: _category,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _coverFallback() => Container(
    color: const Color(0xFFF1F5F9),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_rounded, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'SEDNEX EMBASSY',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey[400],
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _avatarFallback() => const Icon(
    Icons.flag_rounded,
    size: 40,
    color: Color(0xFF94A3B8),
  );



  // ── Tab Card ──────────────────────────────────────────────────────
  Widget _tabCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom Tab bar
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _tabItem('about'.tr, 0),
                _tabItem('contact'.tr, 1),
              ],
            ),
          ),
          // Dynamic content area (No fixed height)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _selectedTabIndex == 0 ? _aboutTab() : _contactTab(),
          ),
        ],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: _getStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : const Color(0xFF64748B),
                text: title,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── About Tab ─────────────────────────────────────────────────────
  Widget _aboutTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_about.isNotEmpty) ...[
            _label('about'.tr),
            const SizedBox(height: 8),
            Text(
              _about,
              style: _getStyle(
                fontSize: 14,
                color: const Color(0xFF4B5563),
                height: 1.75,
                fontWeight: FontWeight.w400,
                text: _about,
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (_services.isNotEmpty) ...[
            _label('services'.tr),
            const SizedBox(height: 10),
            ..._services.asMap().entries.map((e) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 200 + e.key * 60),
                builder: (_, v, child) => Opacity(
                  opacity: v,
                  child: Transform.translate(
                    offset: Offset(16 * (1 - v), 0),
                    child: child,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5EAF5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e.value,
                          style: _getStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1F2937),
                            text: e.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],

          if (_offDays.isNotEmpty) ...[
            _label('closed_days'.tr),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _offDays
                  .map(
                    (d) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Text(
                        d,
                        style: _getStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          text: d,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],

          if (_direction.isNotEmpty) ...[
            _label('direction'.tr),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9EB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFEBB7)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_rounded, color: Color(0xFFB8860B), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _direction,
                      style: _getStyle(
                        fontSize: 13,
                        color: const Color(0xFF926C00),
                        fontWeight: FontWeight.w500,
                        text: _direction,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (_about.isEmpty && _services.isEmpty && _offDays.isEmpty && _direction.isEmpty)
            const _EmptyState(),
        ],
      ),
    );
  }

  // ── Contact Tab ──────────────────────────────────────────────────
  Widget _contactTab() {
    final allItems = [
      _ContactItem(
        icon: Icons.call_rounded,
        label: 'phone'.tr,
        value: _phone,
        color: AppColors.primary,
        onTap: () async {
          try {
            await launchUrl(Uri(scheme: 'tel', path: _phone));
          } catch (_) {}
        },
      ),
      _ContactItem(
        icon: Icons.alternate_email_rounded,
        label: 'email'.tr,
        value: _email,
        color: AppColors.secondary,
        onTap: () async {
          try {
            await launchUrl(Uri(scheme: 'mailto', path: _email));
          } catch (_) {}
        },
      ),
      _ContactItem(
        icon: Icons.open_in_browser_rounded,
        label: 'website'.tr,
        value: _website,
        color: const Color(0xFFB8860B),
        onTap: () async {
          final uri = Uri.parse(
            _website.startsWith('http') ? _website : 'https://$_website',
          );
          try {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } catch (_) {}
        },
      ),
      _ContactItem(
        icon: Icons.location_on_rounded,
        label: 'address'.tr,
        value: _address,
        color: AppColors.blue3,
        onTap: () async {
          final hasMap = _mapUrl.isNotEmpty;
          final uri = Uri.parse(
            hasMap ? _mapUrl : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}',
          );
          try {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } catch (_) {}
        },
      ),
    ];
    final items = allItems.where((item) => item.value.isNotEmpty).toList();

    if (items.isEmpty) {
      return const _EmptyState();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _buildContactTile(items[i], i),
          if (i < items.length - 1) const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildContactTile(_ContactItem item, int i) {
    final hasValue = item.value.isNotEmpty;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 200 + i * 70),
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - v)),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTap: hasValue ? item.onTap : null,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasValue
                  ? item.color.withValues(alpha: 0.15)
                  : const Color(0xFFE5EAF5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: _getStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: item.color,
                        letterSpacing: 0.6,
                        text: item.label,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasValue ? item.value : '—',
                      style: _getStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: hasValue
                            ? const Color(0xFF111827)
                            : const Color(0xFFD1D5DB),
                        text: hasValue ? item.value : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (hasValue)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Color(0xFFD1D5DB),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: _getStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF9CA3AF),
      letterSpacing: 0.8,
      text: text,
    ),
  );
}

// ── Helper Classes ──────────────────────────────────────────────────
class _ContactItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;
  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.inbox_rounded,
                size: 28,
                color: Color(0xFFD1D5DB),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No information available',
              style: _getStyle(
                fontSize: 14,
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dot Pattern Painter (reserved for future use) ──────────────────
// _DotPainter removed — currently unused
