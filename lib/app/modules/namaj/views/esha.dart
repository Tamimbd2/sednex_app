import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EshaView extends StatelessWidget {
  const EshaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'এশার নামাজ',
          style: GoogleFonts.hindSiliguri(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFC62828),
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
              title: 'এক নজরে এশার নামাজ',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              items: [
                _buildInfoRow('সময়:', 'মাগরিবের ওয়াক্ত শেষ হওয়ার পর থেকে সুবহে সাদিকের আগ পর্যন্ত।'),
                _buildInfoRow('রাকাত:', '৪ ফরজ, ২ সুন্নাত ও ৩ বেতের (ওয়াজিব)। সাথে ৪ সুন্নাত গায়রে মুয়াক্কাদা ও ২ নফল নামাজ আছে। সর্বমোট ১৫ রাকাত।'),
                _buildInfoRow('নিয়ত:', 'আমি কেবলামুখী হয়ে এশার (ফরজ/সুন্নাত/বেতের) নামাজ আদায় করছি।'),
            
              ],
            ),

            const SizedBox(height: 24),

            // Section 2: Time
            _buildSectionHeader(
              icon: Icons.access_time_filled_rounded,
              title: 'এশার নামাজের সময়',
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
                'পশ্চিম আকাশে লালিমা দূর হওয়ার পর এশার নামাজের ওয়াক্ত শুরু হয় এবং সুবহে সাদিকের পূর্ব পর্যন্ত থাকে। এশার নামাজ রাতের প্রথম এক-তৃতীয়াংশ বা অর্ধাংশের মধ্যে আদায় করা উত্তম।',
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
              title: 'এশা নামাজের নিয়ত',
            ),
            
            // 4 Rakat Fard
            const SizedBox(height: 8),
            Text(
              'এশার ৪ রাকাত ফরজ নামাজের নিয়ত',
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى اَرْبَعَ رَكْعَاتِ صَلْوَةِ الْعِشَاءِ فَرْضُ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা আরবা‘আ রাক‘আতি সালাতিল ইশা-ই ফারজুল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),
            
            // 2 Rakat Sunnah
            const SizedBox(height: 20),
            Text(
              'এশার ২ রাকাত সুন্নাত নামাজের নিয়ত',
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى رَكْعَتَى صَلْوَةِ الْعِشَاءِ سُنَّةُ رَسُوْلِ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা রাক‘আতাই সালাতিল ইশা-ই সুন্নাতু রাসুলিল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),

             // 3 Rakat Witr
            const SizedBox(height: 20),
            Text(
              '৩ রাকাত বেতের নামাজের নিয়ত',
              style: GoogleFonts.hindSiliguri(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى ثَلَاثَ رَكْعَاتِ صَلْوَةِ الْوِتْرِ وَاجِبُ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা ছালাছা রাক‘আতি সালাতিল উইত্রি ওয়াজিবুল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),

            const SizedBox(height: 24),

            // Section 4: Method of Prayer
            _buildSectionHeader(
              icon: Icons.menu_book_outlined,
              title: 'এশার নামাজের নিয়ম',
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
                   _buildStepItem(2, 'এশার নামাজের নিয়ত (ফরজ/সুন্নাত/বেতের) করুন।'),
                   _buildStepItem(3, 'তাকবীরে তাহরীমা (আল্লাহু আকবার) বলে হাত বাঁধুন ও ছানা পড়ুন।'),
                   _buildStepItem(4, 'সূরা ফাতেহা ও অন্য একটি সূরা মিলান। (ফরজ নামাজের প্রথম দুই রাকাতে জোরে পড়ুন, ৩য় ও ৪র্থ রাকাতে শুধু সূরা ফাতেহা মনে মনে পড়ুন)।'),
                   _buildStepItem(5, 'রুকু ও সিজদা যথাযথভাবে আদায় করুন।'),
                   _buildStepItem(6, '৪ রাকাত বিশিষ্ট নামাজে ২য় রাকাতে তাশাহুদ পড়ে দাঁড়ান।'),
                   _buildStepItem(7, 'শেষ বৈঠকে তাশাহুদ, দরূদ ও দোয়া মাসূরা পড়ে সালাম ফেরান।'),
                   _buildStepItem(8, '৩ রাকাত বেতের নামাজে ৩য় রাকাতে রুকুর আগে আবার তাকবীরে তাহরীমা বলে হাত বাঁধবেন এবং দোয়া কুনুত পড়বেন।'),
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
              'এশার নামাজ কতক্ষণ পর্যন্ত পড়া যায়?',
              'মধ্যরাতের পূর্বেই এশার নামাজ আদায় করা মুস্তাহাব। সুবহে সাদিকের পূর্ব পর্যন্ত ওয়াক্ত থাকে তবে বিনা ওজরে গভীর রাত পর্যন্ত দেরি করা মাকরূহ।',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'বেতের নামাজের হুকুম কী?',
              'বেতের নামাজ পড়া ওয়াজিব। ফরজ নামাজের মতো গুরুত্ব দিয়ে আদায় করতে হয়। কেউ ছাড়লে গোনাহগার হবে এবং কাজা করতে হবে।',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'দোয়া কুনুত না জানলে কী করবেন?',
              'যদি দোয়া কুনুত জানা না থাকে তবে “রাব্বানা আ-তিনা ফিদ্দুনিয়া হাসানাতাও...” অথবা তিনবার “আল্লাহুম্মাগ ফিরলি” পড়লেও নামাজ হয়ে যাবে। তবে দোয়া কুনুত শিখে নেওয়া জরুরি।',
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
