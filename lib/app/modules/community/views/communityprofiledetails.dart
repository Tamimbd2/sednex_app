import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/url.dart';
import '../../../services/api_service.dart';

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
  State<CommunityProfileDetailsView> createState() =>
      _CommunityProfileDetailsViewState();
}

class _CommunityProfileDetailsViewState
    extends State<CommunityProfileDetailsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _isLoading = true;
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

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

    debugPrint('Fetching details for user ID: $id');

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
      final apiService = Get.find<ApiService>();

      // 1. Try fetching individual user details
      final response = await apiService.getData('api/users/$id');
      debugPrint(
        'User profile individual API response status: ${response.statusCode}',
      );

      if (!response.status.hasError && response.body != null) {
        final body = response.body;
        final fetched = body['user'] ?? body['data'] ?? body;
        if (fetched is Map) {
          setState(() {
            _data.addAll(Map<String, dynamic>.from(fetched));
          });
        }
      }

      // 2. Fallback: If essential details are still missing, try the full users list
      // (The backend singular endpoint might be restricted compared to the plural one)
      if (_val('bio').isEmpty &&
          _val('companyName').isEmpty &&
          _val('phone').isEmpty) {
        debugPrint(
          'Essential details missing, trying fallback to full users list...',
        );
        final listResponse = await apiService.getData('api/users/');
        if (listResponse.statusCode == 200 && listResponse.body != null) {
          final data = listResponse.body;
          if (data['success'] == true && data['users'] is List) {
            final List users = data['users'];
            final foundUser = users.firstWhere(
              (u) => (u['_id'] ?? u['id'] ?? '').toString() == id,
              orElse: () => null,
            );
            if (foundUser != null && foundUser is Map) {
              debugPrint('Found user in full list with details');
              setState(() {
                _data.addAll(Map<String, dynamic>.from(foundUser));
              });
            }
          }
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
    final uri =
        url.startsWith('http') ||
            url.startsWith('tel:') ||
            url.startsWith('mailto:')
        ? Uri.parse(url)
        : Uri.parse('https://$url');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  String _val(String key) => (_data[key]?.toString() ?? '').trim();

  String _formatDateShort(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM').format(date);
    } catch (e) {
      return dateStr;
    }
  }

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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Text(
          'Profile Details',
          style: _getStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1E63FF),
                strokeWidth: 2,
              ),
            )
          : FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [_contentArea(), const SizedBox(height: 40)],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _contentArea() {
    final avatar = _val('profileImage').isNotEmpty
        ? _val('profileImage')
        : _val('image');
    final name = _val('name').isNotEmpty ? _val('name') : _val('fullName');
    final job = _val('jobTitle').isNotEmpty
        ? _val('jobTitle')
        : _val('designation');
    final username = _val('username');
    final tagline = _val('tagline').isNotEmpty
        ? _val('tagline')
        : _val('shortBio');
    final bio = _val('bio').isNotEmpty ? _val('bio') : _val('about');
    final isVerified = _data['isVerified'] == true ||
        _data['verified'] == true ||
        _data['isVerified'] == 'true' ||
        _data['verified'] == 'true' ||
        _data['isVerified'] == 1 ||
        _data['verified'] == 1;

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
              border: Border.all(
                color: const Color(0xFF1E63FF).withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: const Color(0xFFF3F4F6),
              backgroundImage: avatar.isNotEmpty
                  ? CachedNetworkImageProvider(avatar)
                  : null,
              child: avatar.isEmpty
                  ? Icon(
                      Icons.person_rounded,
                      size: 50,
                      color: Colors.grey[400],
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 8),

          // Name & Verified
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: _getStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                  text: name,
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF1E63FF),
                  size: 22,
                ),
              ],
            ],
          ),

          if (username.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '@$username',
              style: _getStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],

          if (job.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              job,
              style: _getStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E63FF),
              ),
              textAlign: TextAlign.center,
            ),
          ],

          if (bio.isEmpty &&
              !_hasPersonalInfo() &&
              !_hasProfessionalInfo() &&
              !_hasLocationInfo() &&
              !_hasSocials() &&
              _val('websiteLink').isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'No data provided',
                  style: _getStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),

          if (bio.isNotEmpty) ...[
            const SizedBox(height: 8),
            Center(child: _labelAlignCenter('Bio')),
            Align(
              alignment: Alignment.center,
              child: Text(
                bio,
                style: _getStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF4B5563),
                  text: bio,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          _buildPersonalInfoChip(),

          if (tagline.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                tagline,
                style: _getStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B5563),
                  text: tagline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          if (_hasProfessionalInfo() || _hasLocationInfo() || _hasSocials() || _val('websiteLink').isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 8),
          ],

          if (_hasProfessionalInfo()) ...[
            const SizedBox(height: 8),
            Center(child: _labelAlignCenter('Professional')),
            const SizedBox(height: 4),
          ],
          _infoSection('', [
            _DetailItem(
              Icons.business_rounded,
              'Company',
              _val('companyName'),
              const Color(0xFF2563EB),
            ),
            _DetailItem(
              Icons.work_rounded,
              'Work Address',
              _val('workAddress'),
              const Color(0xFF4F46E5),
            ),
          ]),

          if (_hasLocationInfo()) ...[
            const SizedBox(height: 8),
            Center(child: _labelAlignCenter('Location')),
            const SizedBox(height: 4),
          ],
          _infoSection('', [
            _DetailItem(
              Icons.location_city_rounded,
              'Current Address',
              _val('currentAddress'),
              const Color(0xFF7C3AED),
            ),
            _DetailItem(
              Icons.public_rounded,
              'Country',
              _val('country'),
              const Color(0xFFD97706),
            ),
          ]),

          if (_hasSocials()) ...[
            const SizedBox(height: 4),
            Center(child: _labelAlignCenter('Social Profiles')),
            const SizedBox(height: 4),
            Center(child: _socialLinksRow()),
          ],

          if (_val('websiteLink').isNotEmpty) ...[
            const SizedBox(height: 4),
            _infoSection('', [
              _DetailItem(
                Icons.language_rounded,
                'Website',
                _val('websiteLink'),
                const Color(0xFF0891B2),
                onTap: () => _launch(_val('websiteLink')),
              ),
            ]),
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
        if (title.isNotEmpty) ...[
          _labelAlignLeft(title),
          const SizedBox(height: 4),
        ],
        for (var i = 0; i < validItems.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildContactCard(validItems[i])),
                if (i + 1 < validItems.length) ...[
                  const SizedBox(width: 8),
                  Expanded(child: _buildContactCard(validItems[i + 1])),
                ] else if (validItems.length > 1)
                  const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContactCard(_DetailItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: _getStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.value,
                      style: _getStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                        text: item.value,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (item.onTap != null)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFFD1D5DB),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasSocials() {
    final social = _data['socialLinks'] ?? {};
    return _val('facebook').isNotEmpty ||
        _val('twitter').isNotEmpty ||
        _val('linkedin').isNotEmpty ||
        social['facebook'] != null ||
        social['linkedin'] != null;
  }

  Widget _socialLinksRow() {
    final social = _data['socialLinks'] ?? {};
    final links = [
      if (_val('facebook').isNotEmpty || social['facebook'] != null)
        {
          'icon': Icons.facebook,
          'url': _val('facebook').isEmpty
              ? social['facebook']
              : _val('facebook'),
          'color': const Color(0xFF1877F2),
        },
      if (_val('linkedin').isNotEmpty || social['linkedin'] != null)
        {
          'icon': Icons.business_center_rounded,
          'url': _val('linkedin').isEmpty
              ? social['linkedin']
              : _val('linkedin'),
          'color': const Color(0xFF0A66C2),
        },
    ];

    return Row(
      children: links
          .map(
            (l) => Padding(
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
                  child: Icon(
                    l['icon'] as IconData,
                    color: l['color'] as Color,
                    size: 22,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _labelAlignCenter(String text) => Text(
    text,
    style: _getStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF1E63FF),
      letterSpacing: 0.5,
    ),
  );

  Widget _labelAlignLeft(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: _getStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1E63FF),
        letterSpacing: 0.5,
      ),
    ),
  );

  bool _hasPersonalInfo() {
    return _val('birthDate').isNotEmpty ||
        _val('gender').isNotEmpty ||
        _val('maritalStatus').isNotEmpty ||
        _val('bloodGroup').isNotEmpty;
  }

  bool _hasProfessionalInfo() {
    return _val('companyName').isNotEmpty || _val('workAddress').isNotEmpty;
  }

  bool _hasLocationInfo() {
    return _val('currentAddress').isNotEmpty || _val('country').isNotEmpty;
  }

  Widget _buildPersonalInfoChip() {
    final items = [
      if (_val('birthDate').isNotEmpty)
        {
          'label': 'Birthday',
          'value': _formatDateShort(_val('birthDate')),
          'icon': Icons.cake_rounded,
        },
      if (_val('gender').isNotEmpty)
        {
          'label': 'Gender',
          'value': _val('gender'),
          'icon': Icons.person_rounded,
        },
      if (_val('maritalStatus').isNotEmpty)
        {
          'label': 'Marital Status',
          'value': _val('maritalStatus'),
          'icon': Icons.favorite_rounded,
        },
      if (_val('bloodGroup').isNotEmpty)
        {
          'label': 'Blood Group',
          'value': _val('bloodGroup'),
          'icon': Icons.bloodtype_rounded,
        },
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(child: _buildInfoItem(items[i])),
                  if (i + 1 < items.length) ...[
                    const SizedBox(width: 6),
                    Expanded(child: _buildInfoItem(items[i + 1])),
                  ] else
                    const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            item['icon'] as IconData,
            size: 16,
            color: const Color(0xFF1E63FF),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['label'] as String,
                  style: _getStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                Text(
                  item['value'] as String,
                  style: _getStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;
  _DetailItem(this.icon, this.label, this.value, this.color, {this.onTap});
}
