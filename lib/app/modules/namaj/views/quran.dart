import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sednexapp/app/core/theme/app_colors.dart';
import 'suradetails.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  var surahList = [].obs;
  var isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    fetchSurahs();
  }

  void fetchSurahs() async {
    try {
      final connect = GetConnect();
      // Using the exact endpoint provided
      final response = await connect.get('https://api.alquran.cloud/v1/surah');
      
      if (response.statusCode == 200) {
        final body = response.body;
        if (body != null && body['data'] is List) {
           surahList.assignAll(body['data']);
        }
      }
    } catch (e) {
      debugPrint("Error fetching surahs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very light gray
      body: Stack(
        children: [
          // Background Gradient decoration
          Positioned(
            top: 0, left: 0, right: 0,
            height: 180, // Reduced height
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary, 
                    AppColors.primary.withOpacity(0.8)
                  ], 
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ), 
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Al Quran',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Search button removed
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                
                // Content Body (List)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Text(
                            'Surah List',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF8789A3),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        
                        Expanded(child: Obx(() {
                          if (isLoading.value) {
                            return const Center(child: CircularProgressIndicator(color: Color(0xFF10A37F)));
                          }
                          
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            itemCount: surahList.length,
                            separatorBuilder: (context, index) => Container(
                               height: 1, 
                               color: const Color(0xFFF1F5F9), 
                               margin: const EdgeInsets.symmetric(vertical: 4)
                            ),
                            itemBuilder: (context, index) {
                              final surah = surahList[index];
                              return InkWell(
                                onTap: () {
                                  Get.to(() => SuraDetailsView(
                                    number: surah['number'],
                                    name: surah['name'],
                                    englishName: surah['englishName'],
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    children: [
                                      // Custom Number Badge (Star Shape)
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Transform.rotate(
                                            angle: 0.785, // 45 degrees
                                            child: Container(
                                              width: 36, height: 36,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: const Color(0xFF10A37F), width: 1.5),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${surah['number']}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF101727),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              surah['englishName'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF240F4F),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  surah['revelationType'].toString().toUpperCase(), 
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xFF8789A3),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                const CircleAvatar(
                                                  radius: 2, 
                                                  backgroundColor: Color(0xFFBBC4CE)
                                                ),
                                                 const SizedBox(width: 5),
                                                Text(
                                                  '${surah['numberOfAyahs']} VERSES',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xFF8789A3),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      
                                      Text(
                                        surah['name'],
                                        style: GoogleFonts.amiri(
                                          fontSize: 20,
                                          color: const Color(0xFF863ED5), // Purple accent
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        })),
                      ],
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
}
