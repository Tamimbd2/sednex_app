import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SuraDetailsView extends StatefulWidget {
  final int number;
  final String name;
  final String englishName;

  const SuraDetailsView({
    super.key,
    required this.number,
    required this.name,
    required this.englishName,
  });

  @override
  State<SuraDetailsView> createState() => _SuraDetailsViewState();
}

class _SuraDetailsViewState extends State<SuraDetailsView> {
  var ayahList = [].obs;
  var isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    fetchSuraDetails();
  }

  void fetchSuraDetails() async {
    try {
      final connect = GetConnect();
      // https://api.alquran.cloud/v1/surah/1/quran-uthmani
      final response = await connect.get(
        'https://api.alquran.cloud/v1/surah/${widget.number}/quran-uthmani'
      );
      
      if (response.statusCode == 200) {
        final body = response.body;
        if (body != null && body['data'] != null && body['data']['ayahs'] is List) {
           ayahList.assignAll(body['data']['ayahs']);
        }
      }
    } catch (e) {
      debugPrint("Error fetching sura details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.englishName,
              style: GoogleFonts.poppins(
                color: const Color(0xFF101727),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              widget.name,
              style: GoogleFonts.amiri(
                color: const Color(0xFF10A37F),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF101727)),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF10A37F)));
        }
        
        // Display full Quran text as a list of verses
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: ayahList.length,
          itemBuilder: (context, index) {
            final ayah = ayahList[index];
            final text = ayah['text'];
            final numberInSurah = ayah['numberInSurah'];
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   // Ayah Actions Row (Optional: Number, Share, Copy)
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Ayah $numberInSurah',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // You can add more icons here like Share/Copy
                     ],
                   ),
                   const SizedBox(height: 12),
                   
                   // Arabic Text
                   Text(
                     text,
                     textAlign: TextAlign.right,
                     style: GoogleFonts.amiri(
                       fontSize: 26,
                       height: 2.2, // Good line height for Arabic
                       color: const Color(0xFF1F2937),
                       fontWeight: FontWeight.w500,
                     ),
                   ),
                   
                   const SizedBox(height: 16),
                   Divider(color: Colors.grey.shade100),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
