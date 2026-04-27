import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_text_styles.dart';

class MagribView extends StatelessWidget {
  const MagribView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'magrib_prayer'.tr,
          style: AppTextStyles.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
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
              title: 'at_a_glance'.tr,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              items: [
                _buildInfoRow('time_label'.tr, 'সূর্যাস্তের পর থেকে আকাশের লাল আভা মিলিয়ে যাওয়া পর্যন্ত।'),
                _buildInfoRow('rakat_label'.tr, '৩ রাকাত ফরজ ও ২ রাকাত সুন্নাত। মোট ৫ রাকাত।'),
                _buildInfoRow('niyat_label'.tr, 'আমি কেবলামুখী হয়ে মাগরিবের (ফরজ/সুন্নাত) নামাজ আদায় করছি।'),
                
              ],
            ),

            const SizedBox(height: 24),

            // Section 2: Time
            _buildSectionHeader(
              icon: Icons.access_time_filled_rounded,
              title: 'prayer_time_header'.tr,
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
                'সূর্য সম্পূর্ণ অস্ত যাওয়ার সাথে সাথে মাগরিবের ওয়াক্ত শুরু হয় এবং পশ্চিম আকাশের লালিমা বা শفق থাকা পর্যন্ত এই ওয়াক্ত থাকে। সাধারণত সূর্য অস্ত যাওয়ার পর থেকে ১ ঘণ্টা পর্যন্ত সময় থাকে।',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section 3: Niyat (Arabic & Bangla)
            _buildSectionHeader(
              icon: Icons.menu_book_rounded,
              title: 'prayer_niyat_header'.tr,
            ),
            
            // 3 Rakat Fard
            const SizedBox(height: 8),
            Text(
              'মাগরিবের ৩ রাকাত ফরজ নামাজের নিয়ত',
              style: AppTextStyles.subHeadingMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى ثَلَاثَ رَكْعَاتِ صَلْوَةِ الْمَغْرِبِ فَرْضُ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা ছালাছা রাক‘আতি সালাতিল মাগরিবি ফারজুল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),
            
            // 2 Rakat Sunnah
            const SizedBox(height: 20),
            Text(
              'মাগরিবের ২ রাকাত সুন্নাত নামাজের নিয়ত',
              style: AppTextStyles.subHeadingMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى رَكْعَتَى صَلْوَةِ الْمَغْرِبِ سُنَّةُ رَسُوْلِ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা রাক‘আতাই সালাতিল মাগরিবি সুন্নাতু রাসুলিল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),

            const SizedBox(height: 24),

            // Section 4: Method of Prayer
            _buildSectionHeader(
              icon: Icons.menu_book_outlined,
              title: 'prayer_method_header'.tr,
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
                   _buildStepItem(2, 'মাগরিবের নামাজের নিয়ত (ফরজ/সুন্নাত) করুন।'),
                   _buildStepItem(3, 'তাকবীরে তাহরীমা (আল্লাহু আকবার) বলে হাত বাঁধুন।'),
                   _buildStepItem(4, 'ছানা পড়ুন।'),
                   _buildStepItem(5, 'সূরা ফাতেহা ও অন্য একটি সূরা মিলান। (ফরজ নামাজের প্রথম দুই রাকাতে জোরে পড়ুন, ৩য় রাকাতে শুধু সূরা ফাতেহা মনে মনে পড়ুন)।'),
                   _buildStepItem(6, 'রুকু করুন এবং ৩ বার সুবহানা রাব্বিয়াল আযীম পড়ুন।'),
                   _buildStepItem(7, 'রুকু থেকে দাঁড়িয়ে সোজা হোন (সামিয়াল্লাহু...) এবং আবার সিজদায় যান।'),
                   _buildStepItem(8, '৩ রাকাত বিশিষ্ট নামাজে ২য় রাকাতে তাশাহুদ পড়ে দাঁড়ান।'),
                   _buildStepItem(9, 'শেষ বৈঠকে তাশাহুদ, দরূদ ও দোয়া মাসূরা পড়ে সালাম ফেরান।'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 5: FAQ
            _buildSectionHeader(
              icon: Icons.help_outline_rounded,
              title: 'faq_header'.tr,
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'কেন মাগরিবের নামাজে দেরি করা উচিত নয়?',
              'হাদিসে এসেছে, যতদিন পর্যন্ত আমার উম্মত মাগরিবের নামাজ আউয়াল ওয়াক্তে (সূর্যাস্তের পরই) আদায় করবে, ততদিন তারা কল্যাণের উপর থাকবে। তাই মাগরিবের নামাজে অযথা দেরি করা অনুচিত।',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'মাগরিবের পরে কি কোনো নফল নামাজ আছে?',
              'মাগরিব ও এশার মাঝখানের সময়টুকু সাধারণত মানুষ অবহেলায় কাটায়। এই সময়ে ৬ রাকাত আউওয়াবিন নামাজ পড়াকে বিশেষ ফজিলতপূর্ণ বলা হয়েছে।',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'মাগরিবের নামাজ যদি কাজা হয়ে যায় তবে কখন পড়তে হবে?',
              'কাজা নামাজ যেকোনো সময় পড়া যায়, তবে নিষিদ্ধ ৩টি সময় (সূর্যোদয়, দ্বিপ্রহর ও সূর্যাস্ত) ব্যতীত।',
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
          style: AppTextStyles.bodyLarge.copyWith(
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
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
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
              style: AppTextStyles.arabic.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'pronunciation_label'.tr,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pronunciation,
            style: AppTextStyles.bodyMedium.copyWith(
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
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
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
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: AppTextStyles.bodyMedium.copyWith(
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

