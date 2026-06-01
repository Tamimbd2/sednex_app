import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sednexapp/app/core/constants/url.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/generalsection_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class GeneralSectionDetailsView extends StatefulWidget {
  const GeneralSectionDetailsView({super.key});

  @override
  State<GeneralSectionDetailsView> createState() => _GeneralSectionDetailsViewState();
}

class _GeneralSectionDetailsViewState extends State<GeneralSectionDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  int _selectedTabIndex = 0;
  bool _isLoading = true;
  String _name = '';
  String _tagline = '';
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
  
  String _slug = '';
  String _sectionTitle = '';

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
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final SectionItem? item = args['item'];
    _sectionTitle = args['title'] ?? 'Details';
    
    final controller = Get.find<GeneralSectionController>();
    _slug = controller.slug;

    final String id = item?.id ?? args['id'] ?? '';
    final String fallbackName = item?.name ?? args['name'] ?? '';
    final String fallbackImage = item?.image ?? args['logoPath'] ?? '';
    final String fallbackCategory = item?.category ?? _sectionTitle;

    setState(() {
      _name = fallbackName;
      _category = fallbackCategory;
      if (item != null) {
        _about = item.about;
        _phone = item.contact.phone;
        _email = item.contact.email;
        _website = item.contact.website;
        _address = item.contact.address;
        _services = item.services;
        _offDays = item.offDays;
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
      final authToken = token ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OWE2NDc4NGFiMjQ3YTI0NTc2MGIxOGIiLCJlbWFpbCI6IlNha2liQHNlZG5leC5jb20iLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3NzQ4NzkwNzUsImV4cCI6MTc3NTQ4Mzg3NX0.SYIpSj3uqab2J8EciPMW0nmb77xe-ld0NHruVyU1Ojs";

      final response = await connect.get(
        '${AppUrl.baseUrl}api/sections/$_slug/items/$id/details',
        headers: {
          'Authorization': 'Bearer $authToken',
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
        // Pick the most complete detail entry
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
          coverPhoto = itemData['image'] ?? itemData['icon'] ?? fallbackImage;
        }

        setState(() {
          _name = itemData['name'] ?? fallbackName;
          _coverPhoto = coverPhoto;
          
          // Essential Tagline
          _tagline = detail['tagline'] ?? detail['note'] ?? detail['shortBio'] ?? '';
          
          _category = itemData['category'] ?? fallbackCategory;
          _about = about['description'] ?? '';
          _bio = detail['bio'] ?? detail['history'] ?? detail['description'] ?? '';
          
          // Top Official Mapping
          _officialName = official['name'] ?? official['fullName'] ?? '';
          _officialDesignation = official['designation'] ?? official['position'] ?? '';
          _officialTagline = official['tagline'] ?? official['bio'] ?? official['shortBio'] ?? '';
          _officialImage = official['image'] ?? official['profileImage'] ?? '';

          // Social Link Mapping
          _facebook = social['facebook'] ?? '';
          _twitter = social['twitter'] ?? social['xProfile'] ?? social['x'] ?? '';
          _linkedin = social['linkedin'] ?? '';
          _instagram = social['instagram'] ?? '';
          _youtube = social['youtube'] ?? '';

          _phone = contact['mobile'] ?? contact['phone'] ?? contact['hotline'] ?? _phone;
          _email = contact['email'] ?? _email;
          _website = contact['website'] ?? _website;
          _address = location['address'] ?? location['fullPhysicalAddress'] ?? _address;
          _direction = contact['direction'] ?? _direction;
          _mapUrl = location['mapUrl'] ?? location['googleMapsUrl'] ?? _mapUrl;
          _services = List<String>.from(about['services'] ?? _services);

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
      debugPrint('$_sectionTitle detail error: $e');
    } finally {
      setState(() => _isLoading = false);
      _animCtrl.forward();
    }
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final Uri uri;
    if (url.startsWith('http') || url.startsWith('mailto:')) {
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
          _name.isEmpty ? _slug.tr : _name,
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
                  style: AppTextStyles.headingMedium.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
              if (_tagline.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _tagline,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (_category.isNotEmpty || _name.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    (_category.isEmpty ? _slug : _category).toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 1.0,
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
          Icon(Icons.business_rounded, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'SEDNEX ${_slug.toUpperCase()}',
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

  Widget _aboutTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_about.isNotEmpty) ...[
            _sectionLabel('about'.tr),
            const SizedBox(height: 8),
            Text(
              _about,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: const Color(0xFF4B5563),
                height: 1.75,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (_bio.isNotEmpty) ...[
            _sectionLabel('information'.tr),
            const SizedBox(height: 8),
            Text(
              _bio,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14,
                color: const Color(0xFF4B5563),
                height: 1.75,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (_officialName.isNotEmpty) ...[
            _sectionLabel('top_official'.tr),
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
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        if (_officialDesignation.isNotEmpty)
                          Text(
                            _officialDesignation,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        if (_officialTagline.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            _officialTagline,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w400,
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
            _sectionLabel('services'.tr),
            const SizedBox(height: 10),
            ..._services.map((s) => _buildServiceItem(s)),
            const SizedBox(height: 20),
          ],
          if (_offDays.isNotEmpty) ...[
            _sectionLabel('closed_days'.tr),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _offDays.map((d) => _buildOffDayChip(d)).toList(),
            ),
            const SizedBox(height: 20),
          ],
          if (_direction.isNotEmpty) ...[
            _sectionLabel('direction'.tr),
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
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 13,
                        color: const Color(0xFF926C00),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_about.isEmpty && _services.isEmpty && _offDays.isEmpty && _direction.isEmpty && _officialName.isEmpty && _bio.isEmpty)
            const _EmptyStateView(),
        ],
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
          onTap: () => _launchUrl(l['url'] as String),
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

  Widget _buildOffDayChip(String day) {
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
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _contactTab() {
    final contactItems = [
      _DetailContactRow(
        icon: Icons.call_rounded,
        label: 'phone'.tr,
        value: _phone,
        color: AppColors.primary,
        onTap: () => launchUrl(Uri(scheme: 'tel', path: _phone)),
      ),
      _DetailContactRow(
        icon: Icons.alternate_email_rounded,
        label: 'email'.tr,
        value: _email,
        color: AppColors.secondary,
        onTap: () => launchUrl(Uri(scheme: 'mailto', path: _email)),
      ),
      _DetailContactRow(
        icon: Icons.open_in_browser_rounded,
        label: 'website'.tr,
        value: _website,
        color: const Color(0xFFB8860B),
        onTap: () => _launchUrl(_website),
      ),
      _DetailContactRow(
        icon: Icons.location_on_rounded,
        label: 'address'.tr,
        value: _address,
        color: AppColors.blue3,
        onTap: () {
          final hasMap = _mapUrl.isNotEmpty;
          final uriString = hasMap 
            ? _mapUrl 
            : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}';
          launchUrl(Uri.parse(uriString), mode: LaunchMode.externalApplication);
        },
      ),
    ];

    final items = contactItems.where((i) => i.value.isNotEmpty).toList();
    if (items.isEmpty) return const _EmptyStateView();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildContactCard(items[i]),
            if (i < items.length - 1) const SizedBox(height: 10),
          ],
          if (_facebook.isNotEmpty || _twitter.isNotEmpty || _linkedin.isNotEmpty || _instagram.isNotEmpty) ...[
            const SizedBox(height: 24),
            _sectionLabel('social_profiles'.tr),
            const SizedBox(height: 12),
            _socialLinksRow(),
          ],
        ],
      ),
    );
  }

  Widget _buildContactCard(_DetailContactRow item) {
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
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: item.color,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF111827),
                    ),
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

  Widget _sectionLabel(String text) => Text(
    text,
    style: AppTextStyles.label.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF9CA3AF),
      letterSpacing: 0.8,
    ),
  );
}

class _DetailContactRow {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;
  _DetailContactRow({required this.icon, required this.label, required this.value, required this.color, required this.onTap});
}

class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();
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
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.inbox_rounded, size: 28, color: Color(0xFFD1D5DB)),
            ),
            const SizedBox(height: 14),
            Text(
              'no_info_available'.tr,
              style: AppTextStyles.bodyMedium.copyWith(
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
