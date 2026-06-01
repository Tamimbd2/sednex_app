import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sednexapp/app/core/constants/url.dart';
import 'package:sednexapp/app/core/theme/app_colors.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/theme/app_text_styles.dart';

class HospitalDetailsView extends StatefulWidget {
  const HospitalDetailsView({super.key});

  @override
  State<HospitalDetailsView> createState() => _HospitalDetailsViewState();
}

class _HospitalDetailsViewState extends State<HospitalDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  int _selectedTabIndex = 0;
  bool _isLoading = true;
  String _name = '';
  String _imageUrl = '';
  String _coverPhoto = '';
  String _phone = '';
  String _email = '';
  String _website = '';
  String _address = '';
  String _about = '';
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
    final String id = args['id'] ?? '';

    // Set basic info from list arguments immediately
    setState(() {
      _name = args['name'] ?? '';
      _imageUrl = args['logoPath'] ?? '';
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
        '${AppUrl.baseUrl}api/sections/hospitals/items/$id/details',
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
        final detail = detailsList.isNotEmpty ? detailsList[0] : {};
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
          _name = itemData['name'] ?? _name;
          _imageUrl = itemData['image'] ?? itemData['icon'] ?? _imageUrl;
          _coverPhoto = coverPhoto;
          _about = about['description'] ?? '';
          _phone = contact['mobile'] ?? contact['phone'] ?? '';
          _email = contact['email'] ?? '';
          _website = contact['website'] ?? '';
          _address = location['address'] ?? contact['direction'] ?? '';
          _services = List<String>.from(about['services'] ?? []);
          final days = offSchedules
              .map<String>((e) => e['day']?.toString() ?? '')
              .where((d) => d.isNotEmpty)
              .toList();
          _offDays = days;
        });

        debugPrint('Hospital details loaded: $_name');
      } else {
        debugPrint('Hospital details API error: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Hospital detail error: $e');
    } finally {
      setState(() => _isLoading = false);
      _animCtrl.forward();
    }
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final Uri uri;
    if (url.startsWith('http') ||
        url.startsWith('mailto:') ||
        url.startsWith('tel:')) {
      uri = Uri.parse(url);
    } else {
      uri = Uri.parse('https://$url');
    }
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar('Error', 'Could not open link');
      }
    } catch (e) {
      Get.snackbar('Error', 'Action not supported');
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
          _name.isEmpty ? 'hospitals'.tr : _name,
          style: AppTextStyles.appBarTitle,
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
            // Gradient Overlay
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
                  style: AppTextStyles.headingSmall.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'hospitals'.tr.toUpperCase(),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
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
          Icon(Icons.local_hospital_rounded, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'SEDNEX HEALTHCARE',
            style: AppTextStyles.bodyMedium.copyWith(
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


  // ── Tab Card ─────────────────────────────────────────────────────
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
          // Dynamic content area
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
          padding: const EdgeInsets.symmetric(vertical: 12),
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
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── About Tab ────────────────────────────────────────────────────
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
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: const Color(0xFF4B5563),
                height: 1.75,
              ),
            ),
            const SizedBox(height: 24),
          ],

          if (_services.isNotEmpty) ...[
            _label('services'.tr),
            const SizedBox(height: 12),
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
                child: _buildServiceItem(e.value),
              );
            }),
            const SizedBox(height: 24),
          ],

          if (_offDays.isNotEmpty) ...[
            _label('closed_days'.tr),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _offDays.map((d) => _dayChip(d)).toList(),
            ),
          ],

          if (_about.isEmpty && _services.isEmpty && _offDays.isEmpty)
            _emptyState(),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayChip(String day) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Text(
        day,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ── Contact Tab ──────────────────────────────────────────────────
  Widget _contactTab() {
    final items = [
      if (_phone.isNotEmpty)
        _ContactItem(
          icon: Icons.call_rounded,
          label: 'phone'.tr,
          value: _phone,
          color: const Color(0xFF3D5AF1),
          onTap: () => _launchUrl('tel:$_phone'),
        ),
      if (_email.isNotEmpty)
        _ContactItem(
          icon: Icons.alternate_email_rounded,
          label: 'email'.tr,
          value: _email,
          color: const Color(0xFF059669),
          onTap: () => _launchUrl('mailto:$_email'),
        ),
      if (_website.isNotEmpty)
        _ContactItem(
          icon: Icons.language_rounded,
          label: 'website'.tr,
          value: _website,
          color: const Color(0xFFD97706),
          onTap: () => _launchUrl(_website),
        ),
      if (_address.isNotEmpty)
        _ContactItem(
          icon: Icons.location_on_rounded,
          label: 'address'.tr,
          value: _address,
          color: const Color(0xFF7C3AED),
          onTap: () => _launchUrl(
            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}',
          ),
        ),
    ];

    if (items.isEmpty) return _emptyState();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 200 + i * 70),
              builder: (_, v, child) => Opacity(
                opacity: v,
                child: Transform.translate(
                  offset: Offset(0, 12 * (1 - v)),
                  child: child,
                ),
              ),
              child: _contactCard(item),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _contactCard(_ContactItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: item.color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.1),
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
                    item.label.toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: item.color,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF6B7280),
          letterSpacing: 0.5,
        ),
      );

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.info_outline_rounded, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No information available',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper Classes ───────────────────────────────────────────────────
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
