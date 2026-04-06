import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sednexapp/app/core/constants/url.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/generalsection_controller.dart';
import '../../../core/theme/app_colors.dart';

class GeneralSectionDetailsView extends StatefulWidget {
  const GeneralSectionDetailsView({super.key});

  @override
  State<GeneralSectionDetailsView> createState() => _GeneralSectionDetailsViewState();
}

class _GeneralSectionDetailsViewState extends State<GeneralSectionDetailsView>
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
  
  String _slug = '';
  String _sectionTitle = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
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
    _tabController.dispose();
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
      _imageUrl = fallbackImage;
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
        final detail = detailsList.isNotEmpty ? detailsList[0] : {};
        final contact = detail['contact'] ?? {};
        final location = detail['location'] ?? {};
        final about = detail['about'] ?? {};
        final List offSchedules = detail['offDaySchedules'] ?? [];

        setState(() {
          _name = itemData['name'] ?? fallbackName;
          _imageUrl = itemData['image'] ?? itemData['icon'] ?? fallbackImage;
          _category = itemData['category'] ?? fallbackCategory;
          _about = about['description'] ?? _about;
          _phone = contact['mobile'] ?? contact['phone'] ?? _phone;
          _email = contact['email'] ?? _email;
          _website = contact['website'] ?? _website;
          _address = location['address'] ?? contact['direction'] ?? _address;
          _services = List<String>.from(about['services'] ?? _services);
          final days = offSchedules
              .map<String>((e) => e['day']?.toString() ?? '')
              .where((d) => d.isNotEmpty)
              .toList();
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
      backgroundColor: const Color(0xFFF5F5F5),
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
          _name.isEmpty ? _sectionTitle : _name,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ).copyWith(
            fontFamilyFallback: [
              GoogleFonts.hindSiliguri().fontFamily!,
            ],
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
                      _profileCard(),
                      if (_address.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _locationRow(),
                      ],
                      const SizedBox(height: 16),
                      _tabCard(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _profileCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: _imageUrl.isNotEmpty
                ? Image.network(
                    _imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.business_rounded, size: 40, color: Colors.grey),
                  )
                : const Icon(Icons.business_rounded, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF2C2C2C),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ).copyWith(
                    fontFamilyFallback: [
                      GoogleFonts.hindSiliguri().fontFamily!,
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _category.isEmpty ? _sectionTitle : _category,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationRow() {
    return GestureDetector(
      onTap: () => _launchUrl(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}',
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
              child: const Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _address,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C2C2C),
                  height: 1.4,
                ).copyWith(
                  fontFamilyFallback: [
                    GoogleFonts.hindSiliguri().fontFamily!,
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFD1D5DB),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Contact'),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 400),
            child: [
              _aboutTab(),
              _contactTab(),
            ][_tabController.index],
          ),
        ],
      ),
    );
  }

  Widget _aboutTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_about.isNotEmpty) ...[
            _sectionLabel('About'),
            const SizedBox(height: 8),
            Text(
              _about,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF4B5563),
                height: 1.75,
                fontWeight: FontWeight.w400,
              ).copyWith(
                fontFamilyFallback: [
                  GoogleFonts.hindSiliguri().fontFamily!,
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (_services.isNotEmpty) ...[
            _sectionLabel('Services'),
            const SizedBox(height: 10),
            ..._services.map((s) => _buildServiceItem(s)),
            const SizedBox(height: 20),
          ],
          if (_offDays.isNotEmpty) ...[
            _sectionLabel('Closed Days'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _offDays
                  .map((d) => _buildOffDayChip(d))
                  .toList(),
            ),
          ],
          if (_about.isEmpty && _services.isEmpty && _offDays.isEmpty)
            const _EmptyStateView(),
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
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1F2937),
              ).copyWith(
                fontFamilyFallback: [
                  GoogleFonts.hindSiliguri().fontFamily!,
                ],
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
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
      ),
    );
  }

  Widget _contactTab() {
    final contactItems = [
      _DetailContactRow(
        icon: Icons.call_rounded,
        label: 'Phone',
        value: _phone,
        color: AppColors.primary,
        onTap: () => launchUrl(Uri(scheme: 'tel', path: _phone)),
      ),
      _DetailContactRow(
        icon: Icons.alternate_email_rounded,
        label: 'Email',
        value: _email,
        color: AppColors.secondary,
        onTap: () => launchUrl(Uri(scheme: 'mailto', path: _email)),
      ),
      _DetailContactRow(
        icon: Icons.open_in_browser_rounded,
        label: 'Website',
        value: _website,
        color: const Color(0xFFB8860B),
        onTap: () => _launchUrl(_website),
      ),
      _DetailContactRow(
        icon: Icons.location_on_rounded,
        label: 'Address',
        value: _address,
        color: AppColors.blue3,
        onTap: () => _launchUrl('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(_address)}'),
      ),
    ];

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      itemCount: contactItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final item = contactItems[i];
        final bool hasValue = item.value.isNotEmpty;
        return GestureDetector(
          onTap: hasValue ? item.onTap : null,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: hasValue ? item.color.withValues(alpha: 0.15) : const Color(0xFFE5EAF5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: item.color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(12)),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: item.color, letterSpacing: 0.6)),
                      const SizedBox(height: 3),
                      Text(
                        hasValue ? item.value : '—',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: hasValue ? const Color(0xFF111827) : const Color(0xFFD1D5DB)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (hasValue) const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFFD1D5DB)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF9CA3AF), letterSpacing: 0.8),
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
            Text('No information available', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
