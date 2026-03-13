import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AcharView extends StatelessWidget {
  const AcharView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'আছরের নামাজ',
          style: GoogleFonts.hindSiliguri(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E63FF),
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
              title: 'এক নজরে আছরের নামাজ',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              items: [
                _buildInfoRow('সময়:', 'যোহরের ওয়াক্ত শেষ হওয়া থেকে সূর্য অস্ত যাওয়ার আগ পর্যন্ত।'),
                _buildInfoRow('রাকাত:', '৪ রাকাত সুন্নাত (গায়রে মুয়াক্কাদা) ও ৪ রাকাত ফরজ। মোট ৮ রাকাত।'),
                _buildInfoRow('নিয়ত:', 'আমি কেবলামুখী হয়ে আছরের (সুন্নাত/ফরজ) নামাজ আদায় করছি।'),
                
              ],
            ),

            const SizedBox(height: 24),

            // Section 2: Time
            _buildSectionHeader(
              icon: Icons.access_time_filled_rounded,
              title: 'আছরের নামাজের সময়',
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
                'যখন কোনো বস্তুর ছায়া দ্বিগুণ (ছায় আসলি বাদে) হয় তখন থেকে আছর শুরু হয়। আছর নামাজের সময় থাকে সূর্য অস্ত যাওয়ার ঠিক আগ পর্যন্ত। তবে সূর্য হলুদ হওয়ার আগেই পড়া উত্তম।',
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
              icon: Icons.menu_book_rounded,
              title: 'আছরের নামাজের নিয়ত',
            ),
            
            // 4 Rakat Sunnah
            const SizedBox(height: 8),
            Text(
              'আছরের ৪ রাকাত সুন্নাত নামাজের নিয়ত',
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى اَرْبَعَ رَكْعَاتِ صَلْوَةِ الْعَصْرِ سُنَّةُ رَسُوْلِ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা আরবা‘আ রাক‘আতি সালাতিল আসরি সুন্নাতু রাসুলিল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),
            
            // 4 Rakat Fard
            const SizedBox(height: 20),
            Text(
              'আছরের ৪ রাকাত ফরজ নামাজের নিয়ত',
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى اَرْبَعَ رَكْعَاتِ صَلْوَةِ الْعَصْرِ فَرْضُ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা আরবা‘আ রাক‘আতি সালাতিল আসরি ফারজুল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),

            const SizedBox(height: 24),

            // Section 4: Method of Prayer
            _buildSectionHeader(
              icon: Icons.menu_book_outlined,
              title: 'আছরের নামাজের নিয়ম',
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
                   _buildStepItem(1, 'প্রথমে পবিত্র হোন ও কিবলামুখী হয়ে দাঁড়ান।'),
                   _buildStepItem(2, 'আছরের নামাজের নিয়ত (সুন্নাত/ফরজ) করুন।'),
                   _buildStepItem(3, 'তাকবীরে তাহরীমা (আল্লাহু আকবার) বলে হাত বাঁধুন।'),
                   _buildStepItem(4, 'ছানা পড়ুন।'),
                   _buildStepItem(5, 'সূরা ফাতেহা ও অন্য একটি সূরা মিলান। (সুন্নাত নামাযে চার রাকাতেই সূরা মিলান, ফরজ নামাজের ৩য় ও ৪র্থ রাকাতে শুধু সূরা ফাতেহা)।'),
                   _buildStepItem(6, 'আছরের ফরজ নামাজে কেরাত মনে মনে (নিঃশব্দে) পড়তে হয়।'),
                   _buildStepItem(7, 'এরপর রুকু করুন এবং তাসবীহ পাঠ করুন।'),
                   _buildStepItem(8, 'রুকু থেকে দাঁড়িয়ে সোজা হোন (সামিয়াল্লাহু...) এবং আবার সিজদায় যান।'),
                   _buildStepItem(9, '৪ রাকাত বিশিষ্ট নামাজে ২য় রাকাতে তাশাহুদ পড়ে দাঁড়ান। শেষ বৈঠকে তাশাহুদ, দরূদ ও দোয়া মাসূরা পড়ে সালাম ফেরান।'),
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
              'আছরের সুন্নাত নামাজ পড়া কি জরুরি?',
              'আছরের সুন্নাত হলো সুন্নতে গায়রে মুয়াক্কাদা। এটি পড়লে সওয়াব আছে, না পড়লে গুনাহ নেই। তবে পড়া উত্তম।',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'আছরের নামাজ কখন নিষিদ্ধ?',
              'সূর্য অস্ত যাওয়ার ২০ মিনিট আগে যখন সূর্যের রঙ হলুদ হয়ে যায়, তখন নামাজ পড়া মাকরূহ। তবে ওই দিনের আছর নামাজ পড়া না হয়ে থাকলে মাকরূহ ওয়াক্তেও পড়ে নিতে হবে।',
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
        Icon(icon, color: const Color(0xFF1E63FF), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.hindSiliguri(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E63FF),
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
              color: Color(0xFF1E63FF), // Red circle
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

