import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/url.dart';

// ── Font Helper ──────────────────────────────────────────────────
TextStyle _getStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
  double? letterSpacing,
  String? text,
}) {
  bool isBangla = false;
  if (text != null) {
    isBangla = RegExp(r'[\u0980-\u09FF]').hasMatch(text);
  }
  return isBangla
      ? GoogleFonts.hindSiliguri(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
        )
      : GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
        );
}

class CommunityProfileDetailsView extends StatefulWidget {
  final dynamic member;
  const CommunityProfileDetailsView({super.key, required this.member});

  @override
  State<CommunityProfileDetailsView> createState() => _CommunityProfileDetailsViewState();
}

class _CommunityProfileDetailsViewState extends State<CommunityProfileDetailsView> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _isLoading = true;
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    _fetchDetails();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDetails() async {
    final member = widget.member is Map ? widget.member : {};
    final String id = (member['_id'] ?? member['id'] ?? '').toString();

    // Initial data from passed object
    setState(() {
      _data = Map<String, dynamic>.from(member);
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
        '${AppUrl.baseUrl}api/users/$id',
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );

      if (!response.status.hasError && response.body != null) {
        final fetched = response.body['user'] ?? response.body['data'] ?? response.body;
        if (fetched is Map) {
          setState(() {
            _data.addAll(Map<String, dynamic>.from(fetched));
          });
        }
      }
    } catch (e) {
      debugPrint('User detail fetch error: $e');
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

  String _val(String key) => (_data[key]?.toString() ?? '').trim();
  
  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM, yyyy').format(date);
    } catch (e) {
      return dateStr;
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
        title: Text(
          'Profile Details',
          style: _getStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E63FF), strokeWidth: 2))
          : FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      _contentArea(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _contentArea() {
    final avatar = _val('profileImage').isNotEmpty ? _val('profileImage') : _val('image');
    final name = _val('name').isNotEmpty ? _val('name') : _val('fullName');
    final job = _val('jobTitle').isNotEmpty ? _val('jobTitle') : _val('designation');
    final role = _val('role');
    final tagline = _val('tagline').isNotEmpty ? _val('tagline') : _val('shortBio');
    final bio = _val('bio').isNotEmpty ? _val('bio') : _val('about');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Minimal Centered Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1E63FF).withValues(alpha: 0.1), width: 2),
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: const Color(0xFFF3F4F6),
              backgroundImage: avatar.isNotEmpty ? CachedNetworkImageProvider(avatar) : null,
              child: avatar.isEmpty ? Icon(Icons.person_rounded, size: 50, color: Colors.grey[400]) : null,
            ),
          ),
          const SizedBox(height: 24),
          
          // Name & Verified
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: _getStyle(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF111827), text: name)),
              const SizedBox(width: 6),
              const Icon(Icons.verified_rounded, color: Color(0xFF1E63FF), size: 22),
            ],
          ),
          
          if (job.isNotEmpty || role.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              job.isNotEmpty ? '$job • $role' : role,
              style: _getStyle(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF1E63FF)),
              textAlign: TextAlign.center,
            ),
          ],

          if (tagline.isNotEmpty) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                tagline,
                style: _getStyle(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF4B5563), text: tagline),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          const SizedBox(height: 32),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 32),

          if (bio.isNotEmpty) ...[
            _labelAlignLeft('Biography'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                bio,
                style: _getStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF4B5563), text: bio),
              ),
            ),
            const SizedBox(height: 24),
          ],

          _infoSection('Professional Information', [
            _DetailItem(Icons.business_rounded, 'Company', _val('companyName'), const Color(0xFF2563EB)),
            _DetailItem(Icons.work_rounded, 'Work Address', _val('workAddress'), const Color(0xFF4F46E5)),
            _DetailItem(Icons.language_rounded, 'Website', _val('websiteLink'), const Color(0xFF0891B2), onTap: () => _launch(_val('websiteLink'))),
          ]),

          _infoSection('Personal Details', [
            _DetailItem(Icons.bloodtype_rounded, 'Blood Group', _val('bloodGroup'), const Color(0xFFDC2626)),
            _DetailItem(Icons.cake_rounded, 'Birth Date', _formatDate(_val('birthDate')), const Color(0xFFD97706)),
            _DetailItem(Icons.favorite_rounded, 'Marital Status', _val('maritalStatus'), const Color(0xFFE11D48)),
            _DetailItem(Icons.flag_rounded, 'Nationality', _val('nationality'), const Color(0xFF059669)),
            _DetailItem(Icons.person_outline_rounded, 'Gender', _val('gender'), const Color(0xFFDB2777)),
          ]),

          _infoSection('Contact & Location', [
            _DetailItem(Icons.alternate_email_rounded, 'Email', _val('email'), const Color(0xFF059669), onTap: () => _launch('mailto:${_val('email')}')),
            _DetailItem(Icons.call_rounded, 'Phone', _val('phone'), const Color(0xFF3B82F6), onTap: () => _launch('tel:${_val('phone')}')),
            _DetailItem(Icons.public_rounded, 'Country', _val('country'), const Color(0xFFD97706)),
            _DetailItem(Icons.location_city_rounded, 'Current Address', _val('currentAddress'), const Color(0xFF7C3AED)),
            _DetailItem(Icons.home_rounded, 'Birth Place', _val('birthAddress'), const Color(0xFF6366F1)),
          ]),

          if (_hasSocials()) ...[
            const SizedBox(height: 32),
            _labelAlignLeft('Social Profiles'),
            const SizedBox(height: 16),
            _socialLinksRow(),
          ],
        ],
      ),
    );
  }

  Widget _infoSection(String title, List<_DetailItem> items) {
    final validItems = items.where((i) => i.value.isNotEmpty).toList();
    if (validItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelAlignLeft(title),
        const SizedBox(height: 12),
        ...validItems.map((item) => _buildContactCard(item)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContactCard(_DetailItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFF), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: item.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label, style: _getStyle(fontSize: 10, fontWeight: FontWeight.w700, color: item.color.withValues(alpha: 0.8), letterSpacing: 0.5)),
                    const SizedBox(height: 2),
                    Text(item.value, style: _getStyle(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF111827), text: item.value)),
                  ],
                ),
              ),
              if (item.onTap != null) const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFFD1D5DB)),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasSocials() {
    final social = _data['socialLinks'] ?? {};
    return _val('facebook').isNotEmpty || _val('twitter').isNotEmpty || _val('linkedin').isNotEmpty ||
           social['facebook'] != null || social['linkedin'] != null;
  }

  Widget _socialLinksRow() {
    final social = _data['socialLinks'] ?? {};
    final links = [
      if (_val('facebook').isNotEmpty || social['facebook'] != null) {'icon': Icons.facebook, 'url': _val('facebook').isEmpty ? social['facebook'] : _val('facebook'), 'color': const Color(0xFF1877F2)},
      if (_val('linkedin').isNotEmpty || social['linkedin'] != null) {'icon': Icons.business_center_rounded, 'url': _val('linkedin').isEmpty ? social['linkedin'] : _val('linkedin'), 'color': const Color(0xFF0A66C2)},
    ];

    return Row(
      children: links.map((l) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GestureDetector(
          onTap: () => _launch(l['url'] as String),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: (l['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(l['icon'] as IconData, color: l['color'] as Color, size: 22),
          ),
        ),
      )).toList(),
    );
  }

  Widget _labelAlignLeft(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: _getStyle(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF6B7280), letterSpacing: 0.3)),
      );
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;
  _DetailItem(this.icon, this.label, this.value, this.color, {this.onTap});
}
