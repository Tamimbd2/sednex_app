import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_text_styles.dart';

class ZoharView extends StatelessWidget {
  const ZoharView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'zohar_prayer'.tr,
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
                _buildInfoRow('time_label'.tr, 'সূর্য পশ্চিম আকাশে ঢলে পড়ার পর হতে আসরের ওয়াক্ত শুরু হওয়ার আগ পর্যন্ত।'),
                _buildInfoRow('rakat_label'.tr, '৪ রাকাত সুন্নাত, ৪ রাকাত ফরজ, ২ রাকাত সুন্নাত ও ২ রাকাত নফল। মোট ১২ রাকাত।'),
                _buildInfoRow('niyat_label'.tr, 'আমি কেবলামুখী হয়ে যোহরের (সুন্নাত/ফরজ) নামাজ আদায় করছি।'),
            
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
                'সূর্য ঠিক মধ্যাকাশ থেকে পশ্চিমে ঢলে পড়লেই যোহরের ওয়াক্ত শুরু হয় এবং কোনো বস্তুর ছায়া দ্বিগুণ হওয়া পর্যন্ত (ছায় আসলি বাদে) এই ওয়াক্ত থাকে।',
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
            
            // 4 Rakat Sunnah
            const SizedBox(height: 8),
            Text(
              'যোহরের ৪ রাকাত সুন্নাত নামাজের নিয়ত',
              style: AppTextStyles.subHeadingMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى اَرْبَعَ رَكْعَاتِ صَلْوَةِ الظُّهْرِ سُنَّةُ رَسُوْلِ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা আরবা‘আ রাক‘আতি সালাতিজ জুহরি সুন্নাতু রাসুলিল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),
            
            // 4 Rakat Fard
            const SizedBox(height: 20),
            Text(
              'যোহরের ৪ রাকাত ফরজ নামাজের নিয়ত',
              style: AppTextStyles.subHeadingMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى اَرْبَعَ رَكْعَاتِ صَلْوَةِ الظُّهْرِ فَرْضُ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা আরবা‘আ রাক‘আতি সালাতিজ জুহরি ফারজুল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
            ),

            // 2 Rakat Sunnah
            const SizedBox(height: 20),
            Text(
              'যোহরের ২ রাকাত সুন্নাত নামাজের নিয়ত',
              style: AppTextStyles.subHeadingMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildArabicCard(
              arabic: 'نَوَيْتُ اَنْ اُصَلِّىَ لِلّهِ تَعَالَى رَكْعَتَى صَلْوَةِ الظُّهْرِ سُنَّةُ رَسُوْلِ اللّهِ',
              pronunciation: 'নাওয়াইতু আন উসাল্লিয়া লিল্লাহি তা‘আলা রাক‘আতাই সালাতিজ জুহরি সুন্নাতু রাসুলিল্লাহি তা‘আলা, মুতাওয়াজ্জিহান ইলা জিহাতিল কা‘বাতিশ শারীফাতি - আল্লাহু আকবার',
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
                   _buildStepItem(2, 'যোহরের নামাজের নিয়ত (সুন্নাত/ফরজ) করুন।'),
                   _buildStepItem(3, 'তাকবীরে তাহরীমা (আল্লাহু আকবার) বলে হাত বাঁধুন।'),
                   _buildStepItem(4, 'ছানা পড়ুন।'),
                   _buildStepItem(5, 'সূরা ফাতেহা ও অন্য একটি সূরা মিলান (ফরজ নামাজের ৩য় ও ৪র্থ রাকাতে শুধু সূরা ফাতেহা)।'),
                   _buildStepItem(6, 'যোহরের ফরজ নামাজে ইমাম ও মুক্তাদী উভয়েই মনে মনে (নিঃশব্দে) কেরাত পড়বেন।'),
                   _buildStepItem(7, 'এরপর রুকু করুন এবং তাসবীহ পাঠ করুন।'),
                   _buildStepItem(8, 'রুকু থেকে দাঁড়িয়ে সোজা হোন (তাসমি ও তাহমিদ পড়ুন)।'),
                   _buildStepItem(9, 'সিজদায় যান এবং তাসবীহ পড়ুন। দুইটি সিজদা আদায় করুন।'),
                   _buildStepItem(10, 'চার রাকাত বিশিষ্ট নামাজে ২য় রাকাতে তাশাহুদ পড়ে দাঁড়ান। শেষ বৈঠকে তাশাহুদ, দরূদ ও দোয়া মাসূরা পড়ে সালাম ফেরান।'),
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
              'যোহরের নামাজ কখন আদায় করতে হয়?',
              'সূর্য ঢলে পড়ার পর হতে শুরু হয়ে আসরের ওয়াক্ত শুরু হওয়ার আগ পর্যন্ত যোহরের নামাজ আদায় করা যায়।',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'যোহরের নামাজ কয় রাকাত?',
              'যোহরের নামাজ মোট ১২ রাকাত। ৪ সুন্নাত (মুয়াক্কাদা), ৪ ফরজ, ২ সুন্নাত (মুয়াক্কাদা) ও ২ নফল।',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              'কেউ যদি ৪ রাকাত সুন্নাত না পড়তে পারে তবে কি তার নামাজ হবে?',
              'যোহরের আগের ৪ রাকাত সুন্নাত হলো সুন্নতে মুয়াক্কাদা। বিনা কারণে এটি ছেড়ে দিলে গুনাহ হবে। তবে সময়ের অভাবে শুধু ফরজ পড়লে ফরজ আদায় হবে।',
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

