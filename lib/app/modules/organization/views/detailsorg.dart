import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sednexapp/app/core/constants/url.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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

class OrganizationDetailsView extends StatefulWidget {
  const OrganizationDetailsView({super.key});

  @override
  State<OrganizationDetailsView> createState() =>
      _OrganizationDetailsViewState();
}

class _OrganizationDetailsViewState extends State<OrganizationDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  int _selectedTabIndex = 0;
  bool _isLoading = true;
  String _name = '';
  String _tagline = '';
  String _imageUrl = '';
  String _coverPhoto = '';
  String _category = '';
  String _about = '';
  String _bio = '';
  
  // Top Official
  String _officialName = '';
  String _officialDesignation = '';
  String _officialTagline = '';
  String _officialImage = '';

  // Social
  String _facebook = '';
  String _twitter = '';
  String _linkedin = '';
  String _instagram = '';
  String _youtube = '';

  String _phone = '';
  String _email = '';
  String _website = '';
  String _address = '';
  String _direction = '';
  String _mapUrl = '';
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
        '${AppUrl.baseUrl}api/sections/organization/items/$id/details',
        headers: {
          'Authorization':
              'Bearer ${token ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OWE2NDc4NGFiMjQ3YTI0NTc2MGIxOGIiLCJlbWFpbCI6IlNha2liQHNlZG5leC5jb20iLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3NzQ4NzkwNzUsImV4cCI6MTc3NTQ4Mzg3NX0.SYIpSj3uqab2J8EciPMW0nmb77xe-ld0NHruVyU1Ojs"}',
        },
      );

      if (!response.status.hasError) {
        var body = response.body;
        if (body is String) {
          try { body = jsonDecode(body); } catch (_) {}
        }

        final itemData = body['item'] ?? {};
        final List detailsList = body['details'] ?? [];
        final detail = detailsList.isNotEmpty
            ? detailsList.firstWhere(
                (d) => d['contact'] != null || d['about'] != null,
                orElse: () => detailsList[0],
              )
            : {};
        final contact = detail['contact'] ?? {};
        final location = detail['location'] ?? {};
        final about = detail['about'] ?? {};
        final official = detail['topOfficial'] ?? {};
        final social = detail['socialLinks'] ?? {};
        final List offSchedules = detail['offDaySchedules'] ?? [];

        // Find coverPhoto from any detail entry
        String coverPhoto = '';
        for (final d in detailsList) {
          if (d['coverPhoto'] != null && d['coverPhoto'].toString().isNotEmpty) {
            coverPhoto = d['coverPhoto'].toString();
            break;
          }
        }

        setState(() {
          _name = itemData['name'] ?? _name;
          _imageUrl = itemData['image'] ?? itemData['icon'] ?? _imageUrl;
          _coverPhoto = coverPhoto;
          _tagline = detail['tagline'] ?? detail['note'] ?? detail['shortBio'] ?? '';
          _category = itemData['category'] ?? 'Organization';
          
          _about = about['description'] ?? '';
          _bio = detail['bio'] ?? detail['history'] ?? detail['description'] ?? '';
          
          _officialName = official['name'] ?? official['fullName'] ?? '';
          _officialDesignation = official['designation'] ?? official['position'] ?? '';
          _officialTagline = official['tagline'] ?? official['bio'] ?? official['shortBio'] ?? '';
          _officialImage = official['image'] ?? official['profileImage'] ?? '';

          _facebook = social['facebook'] ?? '';
          _twitter = social['twitter'] ?? social['xProfile'] ?? social['x'] ?? '';
          _linkedin = social['linkedin'] ?? '';
          _instagram = social['instagram'] ?? '';
          _youtube = social['youtube'] ?? '';

          _phone = contact['mobile'] ?? contact['phone'] ?? contact['hotline'] ?? '';
          _email = contact['email'] ?? '';
          _website = contact['website'] ?? '';
          _address = location['address'] ?? location['fullPhysicalAddress'] ?? '';
          _direction = contact['direction'] ?? _direction;
          _mapUrl = location['mapUrl'] ?? location['googleMapsUrl'] ?? '';
          _services = List<String>.from(about['services'] ?? []);

          // Handle potentially nested or simple offSchedules
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
      debugPrint('Org detail error: $e');
    } finally {
      setState(() => _isLoading = false);
      _animCtrl.forward();
    }
  }

  Future<void> _launch(String url) async {
    if (url.isEmpty) return;
    final uri = url.startsWith('http') || url.startsWith('tel:') || url.startsWith('mailto:')
        ? Uri.parse(url) : Uri.parse('https://$url');
    try { await launchUrl(uri, mode: LaunchMode.externalApplication); } catch (_) {}
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
          _name.isEmpty ? 'details'.tr : _name,
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
    final hasAvatar = _imageUrl.isNotEmpty;

    if (!hasCover && !hasAvatar && _name.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasCover || hasAvatar)
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover Photo
              if (hasCover)
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                  ),
                  child: Image.network(
                    _coverPhoto,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                )
              else if (hasAvatar)
                const SizedBox(height: 100),

              // Profile Avatar
              if (hasAvatar)
                Positioned(
                  bottom: hasCover ? -40 : 0,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Container(
                        width: 80,
                        height: 80,
                        color: const Color(0xFFF8FAFC),
                        child: Image.network(
                          _imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.business_rounded, size: 40, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        
        SizedBox(height: (hasCover && hasAvatar) ? 50 : (hasAvatar ? 10 : 20)),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_name.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        _name,
                        style: _getStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                          text: _name,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.verified_rounded, color: AppColors.accent, size: 20),
                  ],
                ),
              if (_tagline.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  _tagline,
                  style: _getStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    text: _tagline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (_category.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  _category,
                  style: _getStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    text: _category,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

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

          if (_bio.isNotEmpty) ...[
            _label('information'.tr),
            const SizedBox(height: 8),
            Text(
              _bio,
              style: _getStyle(
                fontSize: 14,
                color: const Color(0xFF4B5563),
                height: 1.75,
                fontWeight: FontWeight.w400,
                text: _bio,
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (_officialName.isNotEmpty) ...[
            _label('top_official'.tr),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5EAF5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: _officialImage.isNotEmpty
                          ? Image.network(_officialImage, fit: BoxFit.cover)
                          : const Icon(Icons.person_rounded, color: Color(0xFF94A3B8)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _officialName,
                          style: _getStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                            text: _officialName,
                          ),
                        ),
                        if (_officialDesignation.isNotEmpty)
                          Text(
                            _officialDesignation,
                            style: _getStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                              text: _officialDesignation,
                            ),
                          ),
                        if (_officialTagline.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            _officialTagline,
                            style: _getStyle(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w400,
                              text: _officialTagline,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (_services.isNotEmpty) ...[
            _label('services'.tr),
            const SizedBox(height: 10),
            ..._services.map((s) => _buildServiceItem(s)),
            const SizedBox(height: 20),
          ],
          if (_offDays.isNotEmpty) ...[
            _label('closed_days'.tr),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _offDays.map((d) => _dayChip(d)).toList(),
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
          if (_about.isEmpty && _services.isEmpty && _offDays.isEmpty && _direction.isEmpty && _officialName.isEmpty && _bio.isEmpty)
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
            decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: _getStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
                text: text,
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
        style: _getStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          text: day,
        ),
      ),
    );
  }

  // ── Contact Tab ───────────────────────────────────────────────────
  Widget _contactTab() {
    final contacts = [
      _DetailRow(
        icon: Icons.call_rounded,
        label: 'phone'.tr,
        value: _phone,
        color: const Color(0xFF3D5AF1),
        onTap: () => _launch('tel:$_phone'),
      ),
      _DetailRow(
        icon: Icons.alternate_email_rounded,
        label: 'email'.tr,
        value: _email,
        color: const Color(0xFF059669),
        onTap: () => _launch('mailto:$_email'),
      ),
      _DetailRow(
        icon: Icons.language_rounded,
        label: 'website'.tr,
        value: _website,
        color: const Color(0xFFD97706),
        onTap: () => _launch(_website),
      ),
      _DetailRow(
        icon: Icons.location_on_rounded,
        label: 'address'.tr,
        value: _address.isNotEmpty ? _address : _direction,
        color: const Color(0xFF7C3AED),
        onTap: () {
          final hasMap = _mapUrl.isNotEmpty;
          final uriString = hasMap 
            ? _mapUrl 
            : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}';
          launchUrl(Uri.parse(uriString), mode: LaunchMode.externalApplication);
        },
      ),
    ];

    final items = contacts.where((i) => i.value.isNotEmpty).toList();
    if (items.isEmpty) return _emptyState();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildContactCard(items[i]),
            if (i < items.length - 1) const SizedBox(height: 10),
          ],
          if (_facebook.isNotEmpty || _twitter.isNotEmpty || _linkedin.isNotEmpty || _instagram.isNotEmpty || _youtube.isNotEmpty) ...[
            const SizedBox(height: 24),
            _label('social_profiles'.tr),
            const SizedBox(height: 12),
            _socialLinksRow(),
          ],
        ],
      ),
    );
  }

  Widget _buildContactCard(_DetailRow item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: item.color.withValues(alpha: 0.15)),
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
                    style: _getStyle(fontSize: 10, fontWeight: FontWeight.w700, color: item.color, letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.value,
                    style: _getStyle(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF111827), text: item.value),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFFD1D5DB)),
          ],
        ),
      ),
    );
  }

  Widget _socialLinksRow() {
    final links = [
      if (_facebook.isNotEmpty) {'icon': Icons.facebook, 'url': _facebook, 'color': const Color(0xFF1877F2)},
      if (_twitter.isNotEmpty) {'icon': Icons.alternate_email_rounded, 'url': _twitter, 'color': const Color(0xFF000000)},
      if (_linkedin.isNotEmpty) {'icon': Icons.business_center_rounded, 'url': _linkedin, 'color': const Color(0xFF0A66C2)},
      if (_instagram.isNotEmpty) {'icon': Icons.camera_alt_rounded, 'url': _instagram, 'color': const Color(0xFFE4405F)},
      if (_youtube.isNotEmpty) {'icon': Icons.play_circle_fill_rounded, 'url': _youtube, 'color': const Color(0xFFFF0000)},
    ];

    return Row(
      children: links.map((l) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GestureDetector(
          onTap: () => _launch(l['url'] as String),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (l['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(l['icon'] as IconData, color: l['color'] as Color, size: 22),
          ),
        ),
      )).toList(),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: _getStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF6B7280),
          letterSpacing: 0.3,
          text: text,
        ),
      );

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.info_outline_rounded, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text('No information available',
                style: _getStyle(
                    fontSize: 14,
                    color: Colors.grey[400]!,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ── Data Classes ──────────────────────────────────────────────────────
class _DetailRow {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });
}
