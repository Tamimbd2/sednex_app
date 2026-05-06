
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../../../services/api_service.dart';
import '../../../core/theme/app_text_styles.dart';

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
      ? GoogleFonts.hindSiliguri(fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing)
      : GoogleFonts.poppins(fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);
}

class CommunityProfileDetailsView extends StatefulWidget {
  final dynamic member;
  const CommunityProfileDetailsView({super.key, required this.member});

  @override
  State<CommunityProfileDetailsView> createState() => _CommunityProfileDetailsViewState();
}

class _CommunityProfileDetailsViewState extends State<CommunityProfileDetailsView> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final member = widget.member is Map ? widget.member : {};
    final String id = (member['_id'] ?? member['id'] ?? '').toString();
    setState(() { _data = Map<String, dynamic>.from(member); });

    if (id.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final apiService = Get.find<ApiService>();
      final response = await apiService.getData('api/users/$id');
      if (!response.status.hasError && response.body != null) {
        final body = response.body;
        final fetched = body['user'] ?? body['data'] ?? body;
        if (fetched is Map) {
          setState(() { _data.addAll(Map<String, dynamic>.from(fetched)); });
        }
      }
      
      if (response.statusCode == 404 || _val('bio').isEmpty) {
        final listResponse = await apiService.getData('api/users/');
        if (listResponse.statusCode == 200 && listResponse.body != null) {
          final List users = listResponse.body['users'] ?? [];
          final found = users.firstWhere((u) => (u['_id'] ?? u['id'] ?? '').toString() == id, orElse: () => null);
          if (found != null) setState(() { _data.addAll(Map<String, dynamic>.from(found)); });
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _val(String key) => (_data[key]?.toString() ?? '').trim();

  String _formatDateShort(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM').format(date);
    } catch (e) { return dateStr; }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _val('profileImage').isNotEmpty ? _val('profileImage') : _val('image');
    final name = _val('name').isNotEmpty ? _val('name') : _val('fullName');
    final job = _val('jobTitle').isNotEmpty ? _val('jobTitle') : _val('designation');
    final isVerified = _data['isVerified'] == true || _data['verified'] == true;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E63FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Profile Details', style: AppTextStyles.headingMedium.copyWith(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1E63FF)))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Header Section
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color(0xFFF1F5F9),
                          backgroundImage: avatar.isNotEmpty ? CachedNetworkImageProvider(avatar) : null,
                          child: avatar.isEmpty ? const Icon(Icons.person, size: 45, color: Colors.grey) : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(name, style: _getStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black)),
                            if (isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.verified, color: Color(0xFF1E63FF), size: 20),
                            ],
                          ],
                        ),
                        if (job.isNotEmpty)
                          Text(job.toUpperCase(), style: _getStyle(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1E63FF))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bio Section
                  if (_val('bio').isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(_val('bio'), textAlign: TextAlign.center, style: _getStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[600] ?? Colors.grey)),
                    ),
                    const SizedBox(height: 30),
                  ],

                  // Details Section (Profession, Personal, etc.)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Profession Section
                        if (_val('companyName').isNotEmpty || _val('workAddress').isNotEmpty) ...[
                          _buildModernRow(Icons.business_rounded, 'Company', _val('companyName')),
                          _buildModernRow(Icons.work_outline_rounded, 'Work Address', _val('workAddress')),
                          const SizedBox(height: 10),
                        ],

                        // Personal Info Section
                        _buildModernRow(Icons.location_on_outlined, 'Birth Address', _val('birthAddress').isEmpty ? 'N/A' : _val('birthAddress')),
                        _buildModernRow(Icons.home_outlined, 'Current Address', _val('currentAddress').isEmpty ? 'N/A' : _val('currentAddress')),
                        _buildModernRow(Icons.calendar_today_outlined, 'Birth Date', _val('birthDate').isEmpty ? 'N/A' : _formatDateShort(_val('birthDate'))),
                        _buildModernRow(Icons.person_outline_rounded, 'Gender', _val('gender').isEmpty ? 'N/A' : _val('gender')),
                        _buildModernRow(Icons.favorite_border_rounded, 'Marital Status', _val('maritalStatus').isEmpty ? 'N/A' : _val('maritalStatus')),
                        _buildModernRow(Icons.flag_outlined, 'Nationality', _val('nationality').isEmpty ? 'N/A' : _val('nationality')),
                        _buildModernRow(Icons.bloodtype_outlined, 'Blood Group', _val('bloodGroup').isEmpty ? 'N/A' : _val('bloodGroup')),
                        
                        // Website
                        if (_val('websiteLink').isNotEmpty)
                          _buildModernRow(Icons.language_rounded, 'Website', _val('websiteLink'), isLast: true, onTap: () => _launch(_val('websiteLink'))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Center(
        child: Text(title, style: _getStyle(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF1E63FF))),
      ),
    );
  }

  Widget _buildModernRow(IconData icon, String label, String value, {bool isLast = false, VoidCallback? onTap}) {
    if (value.isEmpty) return const SizedBox.shrink();
    
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF64748B), size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: _getStyle(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF94A3B8))),
                  const SizedBox(height: 2),
                  Text(value, style: _getStyle(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFF1E293B))),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFD1D5DB)),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
