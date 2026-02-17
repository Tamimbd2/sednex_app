import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FajarView extends StatelessWidget {
  const FajarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'ফজরের নামাজ',
          style: GoogleFonts.hindSiliguri(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFC62828), // Deep Red matching screenshot
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: At a Glance
            _buildSectionHeader(
              icon: Icons.info_outline_rounded,
              title: 'এক নজরে ফজরের নামাজ',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              items: [
                _buildInfoRow('সময়:', 'সুবহে সাদিক হতে সূর্যোদয়ের ঠিক আগ পর্যন্ত।'),
                _buildInfoRow('রাকাত:', 'সুন্নাত ২ রাকাত ও ফরজ ২ রাকাত। মোট ৪ রাকাত।'),
                _buildInfoRow('নিয়ত:', 'আমি কেবলামুখী হয়ে ফজরের ২ রাকাত (সুন্নাত/ফরজ) নামাজ আদায় করছি।'),
              ]
            ),

            const SizedBox(height: 24),

            // Section 2: Time
            _buildSectionHeader(
              icon: Icons.access_time_filled_rounded,
              title: 'ফজরের নামাজের সময়',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                'সুবহে সাদিক হতে শুরু হয়, এটি ভোরের প্রথম রশ্মি উঠার শুরু বলতে পারা যায়। সুবহে সাদিক।\n\nশেষ হওয়ার নামাজের সময় সূর্যোদয়ের সাথে শেষ হয়।',
                style: GoogleFonts.hindSiliguri(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section 3: Niyat (Arabic & Bangla)
            _buildSectionHeader(
              icon: Icons.menu_book_rounded, // Assuming icon for Niyat/Rules
              title: 'ফজরের নামাজের নিয়ত',
            ),
            const SizedBox(height: 8),
            Text(
              'ফজরের সুন্নাত নামাজের আরবি নিয়ত',
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى رَكْعَتَى صَلْوَةِ الْفَجْرِ سُنَّةُ رَسُوْلِ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা রাক‘আতাই সালাতিল ফাজরি, সুন্নাতু রাসুলিল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),
            const SizedBox(height: 20),
            Text(
              'ফজরের ফরজ নামাজের আরবি নিয়ত',
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى رَكْعَتَى صَلْوَةِ الْفَجْرِ فَرْضُ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা রাক‘আতাই সালাতিল ফাজরি ফারজুল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),

            const SizedBox(height: 24),

            // Section 4: Method of Prayer
            _buildSectionHeader(
              icon: Icons.menu_book_outlined,
              title: 'ফজরের নামাজের নিয়ম',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildStepItem(1, 'পবিত্রতা অর্জন করে নামাজের স্থানে দাঁড়ানো।'),
                  _buildStepItem(2, 'হৃদয়ে সুন্নাত বা ফরজ নামাজের নিয়ত করা।'),
                  _buildStepItem(3, 'তাকবীরে তাহরীমা বলা ও হাত বাঁধা।'),
                  _buildStepItem(4, 'ছানা পড়া।'),
                  _buildStepItem(5, 'আউযুবিল্লাহ, বিসমিল্লাহ পড়ে সূরা ফাতিহা এবং অন্য একটি সূরা তিলাওয়াত করা।'),
                  _buildStepItem(6, 'রুকু করা।'),
                  _buildStepItem(7, 'রুকু থেকে সোজা হয়ে দাঁড়ানো।'),
                  _buildStepItem(8, 'দুই সিজদা করা।'),
                  _buildStepItem(9, 'দ্বিতীয় রাকাতে সূরা ফাতিহা এবং অন্য কোনো সূরা পড়ে রুকু করা।'),
                  _buildStepItem(10, 'শয়তানের থেকে বাঁচতে দরূদ/দোয়ে মাসূরা পড়া।'), // Adjusted text slightly based on generic rule
                  _buildStepItem(11, 'সালাম ফিরানো।'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 5: FAQ
            _buildSectionHeader(
              icon: Icons.help_outline_rounded,
              title: 'সচরাচর জিজ্ঞাসা',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'মহিলাদের কি আজান ও ইকামত দিতে হয়?',
              'তাবারানী শরীফে হযরত আসমা বিনতে ইয়াযীদ রা. থেকে বর্ণিত, তিনি বলেন, রাসূলুল্লাহ সা. বলেছেন, নারীদের জন্য আজান ও ইকামত নেই।', // Providing a generic answer as text in screenshot is small
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'ফজরের নামাজ কয় রাকাত?',
              'ফজরের নামাজ মোট ৪ রাকাত। ২ রাকাত সুন্নাত, ২ রাকাত ফরজ।',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'কেন ফজরের সুন্নাত নামাজের ওয়াক্ত হয় ফজরের পর?',
              'ফজরের সুন্নাত ফজরের আগেই পড়া হয়। ফরজ নামাজের পর আর কোনো নফল বা সুন্নাত নেই সূর্যোদয় পর্যন্ত।',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'কেন ফজরের নামাজে আওয়াজ করে কেরাত পড়া হয়?',
              'ফজর, মাগরিব ও এশার ফরজ নামাজের প্রথম দুই রাকাতে এবং জুমার নামাজে ইমাম উচ্চস্বরে কেরাত পড়েন।',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFC62828), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.hindSiliguri(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFC62828),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required List<Widget> items}) {
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0), // Light Orange/Beige
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFE0B2)),
          ),
          child: item,
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: GoogleFonts.hindSiliguri(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.hindSiliguri(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArabicCard({required String arabic, required String pronunciation}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              arabic,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'বাংলা উচ্চারণ:',
            style: GoogleFonts.hindSiliguri(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pronunciation,
            style: GoogleFonts.hindSiliguri(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFC62828), // Red circle
              shape: BoxShape.circle,
            ),
            child: Text(
              '$step',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.hindSiliguri(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.hindSiliguri(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: GoogleFonts.hindSiliguri(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
