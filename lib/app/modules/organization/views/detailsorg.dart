import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sednexapp/app/core/constants/url.dart';
import 'package:get_storage/get_storage.dart';

class OrganizationDetailsView extends StatefulWidget {
  const OrganizationDetailsView({super.key});

  @override
  State<OrganizationDetailsView> createState() =>
      _OrganizationDetailsViewState();
}

class _OrganizationDetailsViewState extends State<OrganizationDetailsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _staggerCtrl;

  bool _isLoading = true;
  String _name = '';
  String _imageUrl = '';
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
    _tabController = TabController(length: 2, vsync: this);
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchDetails());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _staggerCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDetails() async {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String id = args['id'] ?? '';

    setState(() {
      _name = args['name'] ?? '';
      _imageUrl = args['logoPath'] ?? '';
    });

    if (id.isEmpty) {
      setState(() => _isLoading = false);
      _staggerCtrl.forward();
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
        final detail = detailsList.isNotEmpty ? detailsList[0] : {};
        final contact = detail['contact'] ?? {};
        final location = detail['location'] ?? {};
        final about = detail['about'] ?? {};
        final List offSchedules = detail['offDaySchedules'] ?? [];

        setState(() {
          _name = itemData['name'] ?? _name;
          _imageUrl = itemData['image'] ?? itemData['icon'] ?? _imageUrl;
          _about = about['description'] ?? '';
          _phone = contact['mobile'] ?? contact['phone'] ?? '';
          _email = contact['email'] ?? '';
          _website = contact['website'] ?? '';
          _address = location['address'] ?? contact['direction'] ?? '';
          _services = List<String>.from(about['services'] ?? []);
          _offDays = offSchedules
              .map<String>((e) => e['day']?.toString() ?? '')
              .where((d) => d.isNotEmpty)
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Org detail error: $e');
    } finally {
      setState(() => _isLoading = false);
      _staggerCtrl.forward();
    }
  }

  Future<void> _launch(String url) async {
    if (url.isEmpty) return;
    final uri = url.startsWith('http') || url.startsWith('tel:') || url.startsWith('mailto:')
        ? Uri.parse(url) : Uri.parse('https://$url');
    try { await launchUrl(uri, mode: LaunchMode.externalApplication); } catch (_) {}
  }

  Animation<double> _anim(int index) => CurvedAnimation(
    parent: _staggerCtrl,
    curve: Interval(index * 0.1, (index * 0.1 + 0.6).clamp(0, 1),
        curve: Curves.easeOutCubic),
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF3D5AF1),
                  strokeWidth: 2,
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _topHeader(),
                    _body(),
                  ],
                ),
              ),
      ),
    );
  }

  // ── Top Header ────────────────────────────────────────────────────
  Widget _topHeader() {
    return FadeTransition(
      opacity: _anim(0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Status bar + back
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _iconBtn(Icons.arrow_back_rounded, () => Get.back()),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.business_rounded,
                              size: 14, color: Color(0xFF3D5AF1)),
                          const SizedBox(width: 5),
                          Text('Organization',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF3D5AF1))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Avatar + Name
            const SizedBox(height: 12),
            SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0, 0.3), end: Offset.zero)
                  .animate(_anim(1)),
              child: Column(
                children: [
                  // Avatar with ring
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF3D5AF1).withValues(alpha: 0.2),
                          width: 2),
                    ),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEEF2FF),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3D5AF1).withValues(alpha: 0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _imageUrl.isNotEmpty
                            ? Image.network(_imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => _avatarPlaceholder())
                            : _avatarPlaceholder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _name.isEmpty ? 'Organization' : _name,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_rounded,
                          size: 15, color: Color(0xFFFFAB00)),
                      const SizedBox(width: 4),
                      Text('Verified Member',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280))),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Quick Actions Row
            FadeTransition(
              opacity: _anim(2),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Row(
                  children: [
                    if (_phone.isNotEmpty)
                      Expanded(
                          child: _primaryBtn(
                              Icons.call_rounded, 'Call',
                              () => _launch('tel:$_phone'))),
                    if (_phone.isNotEmpty && (_email.isNotEmpty || _website.isNotEmpty))
                      const SizedBox(width: 10),
                    if (_email.isNotEmpty)
                      Expanded(
                          child: _outlineBtn(
                              Icons.email_outlined, 'Email',
                              () => _launch('mailto:$_email'))),
                    if (_email.isNotEmpty && _website.isNotEmpty)
                      const SizedBox(width: 10),
                    if (_website.isNotEmpty)
                      Expanded(
                          child: _outlineBtn(
                              Icons.language_rounded, 'Website',
                              () => _launch(_website))),
                  ],
                ),
              ),
            ),

            // Divider line
            Container(height: 1, color: const Color(0xFFF0F1F5)),
          ],
        ),
      ),
    );
  }

  Widget _avatarPlaceholder() => Container(
        color: const Color(0xFFEEF2FF),
        child: const Icon(Icons.business_rounded,
            size: 48, color: Color(0xFF3D5AF1)),
      );

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF374151)),
      ),
    );
  }

  Widget _primaryBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF3D5AF1),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3D5AF1).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 7),
            Text(label,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _outlineBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF374151), size: 18),
            const SizedBox(width: 7),
            Text(label,
                style: GoogleFonts.inter(
                    color: const Color(0xFF374151),
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────
  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Address card
          if (_address.isNotEmpty) ...[
            FadeTransition(
              opacity: _anim(3),
              child: _addressCard(),
            ),
            const SizedBox(height: 16),
          ],

          // Tab card
          FadeTransition(
            opacity: _anim(4),
            child: _tabCard(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _addressCard() {
    return GestureDetector(
      onTap: () => _launch(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.location_on_rounded,
                  color: Color(0xFF3D5AF1), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF9CA3AF),
                          letterSpacing: 0.5)),
                  const SizedBox(height: 3),
                  Text(_address,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1F2937),
                          height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Maps',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3D5AF1))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Tab Header
          Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: const Color(0xFF111827),
                unselectedLabelColor: const Color(0xFF9CA3AF),
                labelStyle: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: 'About'),
                  Tab(text: 'Contact'),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 500,
            child: TabBarView(
              controller: _tabController,
              children: [_aboutTab(), _contactTab()],
            ),
          ),
        ],
      ),
    );
  }

  // ── About Tab ─────────────────────────────────────────────────────
  Widget _aboutTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_about.isNotEmpty) ...[
            _label('About'),
            const SizedBox(height: 10),
            Text(_about,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF4B5563),
                    height: 1.8)),
            const SizedBox(height: 20),
          ],

          if (_services.isNotEmpty) ...[
            _label('Services'),
            const SizedBox(height: 10),
            ..._services.asMap().entries.map((e) => _serviceRow(e.value, e.key)),
            const SizedBox(height: 20),
          ],

          if (_offDays.isNotEmpty) ...[
            _label('Closed Days'),
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

  Widget _serviceRow(String text, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 60),
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(20 * (1 - v), 0), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF3D5AF1),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF374151),
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayChip(String day) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
      ),
      child: Text(day,
          style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF856404))),
    );
  }

  // ── Contact Tab ───────────────────────────────────────────────────
  Widget _contactTab() {
    final contacts = <_ContactRow>[
      _ContactRow(
        icon: Icons.call_rounded,
        label: 'Phone',
        value: _phone,
        color: const Color(0xFF3D5AF1),
        bg: const Color(0xFFEEF2FF),
        onTap: () => _launch('tel:$_phone'),
      ),
      _ContactRow(
        icon: Icons.alternate_email_rounded,
        label: 'Email',
        value: _email,
        color: const Color(0xFF059669),
        bg: const Color(0xFFECFDF5),
        onTap: () => _launch('mailto:$_email'),
      ),
      _ContactRow(
        icon: Icons.language_rounded,
        label: 'Website',
        value: _website,
        color: const Color(0xFFD97706),
        bg: const Color(0xFFFFFBEB),
        onTap: () => _launch(_website),
      ),
      _ContactRow(
        icon: Icons.location_on_rounded,
        label: 'Address',
        value: _address,
        color: const Color(0xFF7C3AED),
        bg: const Color(0xFFF5F3FF),
        onTap: () => _launch(
            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}'),
      ),
    ];

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: contacts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final c = contacts[i];
        final has = c.value.isNotEmpty;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + i * 70),
          builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(offset: Offset(0, 15 * (1 - v)), child: child),
          ),
          child: GestureDetector(
            onTap: has ? c.onTap : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: has ? Colors.white : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: has
                      ? c.color.withValues(alpha: 0.15)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(c.icon, color: c.color, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.label,
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF9CA3AF))),
                        const SizedBox(height: 2),
                        Text(
                          has ? c.value : 'Not provided',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: has
                                ? const Color(0xFF111827)
                                : const Color(0xFFD1D5DB),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (has)
                    Icon(Icons.chevron_right_rounded,
                        color: c.color.withValues(alpha: 0.5), size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF6B7280),
          letterSpacing: 0.3,
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
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ── Data Classes ──────────────────────────────────────────────────────
class _ContactRow {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
    required this.onTap,
  });
}
