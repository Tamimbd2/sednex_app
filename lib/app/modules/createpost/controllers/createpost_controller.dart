import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../communityFeed/controllers/community_feed_controller.dart';
import '../../../services/api_service.dart';

class CreatepostController extends GetxController {
  final apiService = Get.find<ApiService>();
  
  final textController = TextEditingController();
  final selectedCategory = 'general'.obs;
  final isLoading = false.obs;
  
  final categories = [
    'general',
    'help',
    'sell',
    'job',
    'question',
    'announcement',
    'information',
    'rentals',
  ];

  final RxList<XFile> selectedImages = <XFile>[].obs;
  final RxString postText = ''.obs;

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> createPost() async {
    if (textController.text.trim().isEmpty && selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please enter some text or select an image');
      return;
    }

    try {
      isLoading.value = true;

      // Prepare Multipart Data
      final Map<String, dynamic> body = {
        'description': textController.text.trim(),
        'category': selectedCategory.value,
      };

      // Add Images
      if (selectedImages.isNotEmpty) {
        final List<MultipartFile> files = [];
        for (var image in selectedImages) {
          // Using the path directly often works better with GetConnect for multi-part files
          files.add(MultipartFile(image.path, filename: image.name));
        }
        // Send as 'images' key. If the server expects repeated keys, 
        // GetConnect usually handles List<MultipartFile> by repeating the key or using images[]
        body['images'] = files;
      }

      final formData = FormData(body);

      final response = await apiService.postMultipartData('api/post/', formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        Get.snackbar('Error', 'Failed to create post: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Create Post Error: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEECEF),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 40,
                    color: Color(0xFF1E63FF),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Post Create\nSuccessful',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your post has been successfully created and is now visible to the community.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Color(0xFF4B5563),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    
                    // Trigger refresh of the community feed
                    try {
                      if (Get.isRegistered<CommunityFeedController>()) {
                        Get.find<CommunityFeedController>().refreshPosts();
                      }
                    } catch (e) {
                      debugPrint('Error refreshing feed: $e');
                    }
                    
                    Get.back(); // Back to Feed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E63FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}

