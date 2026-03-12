import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/embassy_controller.dart';
import '../../../core/theme/app_colors.dart';

class EmbassyDetailsView extends StatefulWidget {
  const EmbassyDetailsView({super.key});

  @override
  State<EmbassyDetailsView> createState() => _EmbassyDetailsViewState();
}

class _EmbassyDetailsViewState extends State<EmbassyDetailsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool _isLoading = true;
  String _name = '';
  String _imageUrl = '';
  String _category = '';
  String _about = '';
  String _phone = '';
  String _email = '';
  String _website = '';
  String _address = '';
  List<String> _services = [];
  List<String> _offDays = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animCtrl = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchDetails());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDetails() async {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final Embassy? embassy = args['embassy'];
    if (embassy == null) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _name = embassy.name;
      _imageUrl = embassy.icon;
      _category = embassy.category;
      _about = embassy.about;
      _phone = embassy.contact.phone;
      _email = embassy.contact.email;
      _website = embassy.contact.website;
      _address = embassy.contact.address;
      _services = embassy.services;
      _offDays = embassy.offDays;
    });

    try {
      final connect = GetConnect();
      final response = await connect.get(
        'https://sednex-zvk1.onrender.com/api/sections/embassy/items/${embassy.id}/details',
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
          _name = itemData['name'] ?? embassy.name;
          _imageUrl = itemData['image'] ?? itemData['icon'] ?? embassy.icon;
          _category = itemData['category'] ?? embassy.category;
          _about = about['description'] ?? embassy.about;
          _phone = contact['mobile'] ?? contact['phone'] ?? embassy.contact.phone;
          _email = contact['email'] ?? embassy.contact.email;
          _website = contact['website'] ?? embassy.contact.website;
          _address = location['address'] ?? contact['direction'] ?? embassy.contact.address;
          _services = List<String>.from(about['services'] ?? embassy.services);
          final days = offSchedules.map<String>((e) => e['day']?.toString() ?? '').where((d) => d.isNotEmpty).toList();
          _offDays = days.isEmpty ? embassy.offDays : days;
        });
      }
    } catch (e) {
      debugPrint('Embassy detail error: $e');
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
        ),
        title: Text(
          _name.isEmpty ? 'Embassy' : _name,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: AppColors.primary, strokeWidth: 2))
          : FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _profileCard(),
                      if (_address.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _locationRow(),
                      ],
                      const SizedBox(height: 16),
                      _tabCard(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ── Profile Card ────────────────────────────────────────────────
  Widget _profileCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.accent, Color(0xFFFFF8DC), AppColors.accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: ClipOval(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: _imageUrl.isNotEmpty
                          ? Image.network(_imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _avatarFallback())
                          : _avatarFallback(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0D1B3E),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _category.isEmpty ? 'Embassy' : _category,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded,
                              color: AppColors.accent, size: 10),
                          const SizedBox(width: 3),
                          Text('Verified',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFB8860B))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback() => Container(
        color: AppColors.backgroundAlt,
        child: const Icon(Icons.flag_rounded, size: 36, color: AppColors.primary),
      );


  // ── Location Row ───────────────────────────────────────────────────
  Widget _locationRow() {
    return GestureDetector(
      onTap: () => _launchUrl(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.location_on_rounded,
                  color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _address,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF374151),
                    height: 1.4),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFD1D5DB), size: 20),
          ],
        ),
      ),
    );
  }

  // ── Tab Card ──────────────────────────────────────────────────────
  Widget _tabCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab bar
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.primary,
              unselectedLabelColor: const Color(0xFF9CA3AF),
              labelStyle: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w500),
              tabs: const [Tab(text: 'About'), Tab(text: 'Contact')],
            ),
          ),
          SizedBox(
            height: 460,
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
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_about.isNotEmpty) ...[
            _label('About'),
            const SizedBox(height: 8),
            Text(_about,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF4B5563),
                    height: 1.75,
                    fontWeight: FontWeight.w400)),
            const SizedBox(height: 20),
          ],

          if (_services.isNotEmpty) ...[
            _label('Services'),
            const SizedBox(height: 10),
            ..._services.asMap().entries.map((e) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 200 + e.key * 60),
                builder: (_, v, child) => Opacity(
                    opacity: v,
                    child: Transform.translate(
                        offset: Offset(16 * (1 - v), 0), child: child)),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
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
                        child: Text(e.value,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1F2937))),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
          ],

          if (_offDays.isNotEmpty) ...[
            _label('Closed Days'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _offDays
                  .map((d) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.15)),
                        ),
                        child: Text(d,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                      ))
                  .toList(),
            ),
          ],

          if (_about.isEmpty && _services.isEmpty && _offDays.isEmpty)
            const _EmptyState(),
        ],
      ),
    );
  }

  // ── Contact Tab ──────────────────────────────────────────────────
  Widget _contactTab() {
    final items = [
      _ContactItem(icon: Icons.call_rounded, label: 'Phone',
          value: _phone, color: AppColors.primary, onTap: () async {
            try { await launchUrl(Uri(scheme: 'tel', path: _phone)); } catch (_) {}
          }),
      _ContactItem(icon: Icons.alternate_email_rounded, label: 'Email',
          value: _email, color: AppColors.secondary, onTap: () async {
            try { await launchUrl(Uri(scheme: 'mailto', path: _email)); } catch (_) {}
          }),
      _ContactItem(icon: Icons.open_in_browser_rounded, label: 'Website',
          value: _website, color: const Color(0xFFB8860B), onTap: () async {
            final uri = Uri.parse(_website.startsWith('http') ? _website : 'https://$_website');
            try { await launchUrl(uri, mode: LaunchMode.externalApplication); } catch (_) {}
          }),
      _ContactItem(icon: Icons.location_on_rounded, label: 'Address',
          value: _address, color: AppColors.blue3, onTap: () async {
            final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}');
            try { await launchUrl(uri, mode: LaunchMode.externalApplication); } catch (_) {}
          }),
    ];

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final item = items[i];
        final hasValue = item.value.isNotEmpty;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 200 + i * 70),
          builder: (_, v, child) => Opacity(
              opacity: v,
              child: Transform.translate(
                  offset: Offset(0, 12 * (1 - v)), child: child)),
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
                        : const Color(0xFFE5EAF5)),
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
                        Text(item.label,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: item.color,
                                letterSpacing: 0.6)),
                        const SizedBox(height: 3),
                        Text(
                          hasValue ? item.value : '—',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: hasValue
                                  ? const Color(0xFF111827)
                                  : const Color(0xFFD1D5DB)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (hasValue)
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 12, color: const Color(0xFFD1D5DB)),
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
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF9CA3AF),
          letterSpacing: 0.8,
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
  const _ContactItem(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color,
      required this.onTap});
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
              child: const Icon(Icons.inbox_rounded,
                  size: 28, color: Color(0xFFD1D5DB)),
            ),
            const SizedBox(height: 14),
            Text('No information available',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ── Dot Pattern Painter (reserved for future use) ──────────────────
// _DotPainter removed — currently unused
