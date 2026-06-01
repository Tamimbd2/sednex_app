import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../communityFeed/controllers/community_feed_controller.dart';
import '../../../services/api_service.dart';
import '../../../core/theme/app_text_styles.dart';

class CreatepostController extends GetxController {
  final apiService = Get.find<ApiService>();
  
  final textController = TextEditingController();
  final selectedCategory = 'general'.obs;
  final isLoading = false.obs;
  
  @override
  void onReady() {
    super.onReady();
    _showCategorySelectionDialog();
  }

  void _showCategorySelectionDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'select_category'.tr,
                    style: AppTextStyles.headingSmall.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'category_description'.tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Flexible(
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.2,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Obx(() {
                          final isSelected = selectedCategory.value == category;
                          return GestureDetector(
                            onTap: () {
                              selectCategory(category);
                              Get.back(); // Close dialog after selection
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1E63FF)
                                    : const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF1E63FF)
                                      : Colors.grey.shade200,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  category.tr,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  final categories = [
    'general',
    'jobs',
    'buy_sell',
    'questions',
    'rental',
    'help',
  ];

  final quickTemplates = [
    {
      'title': 'tpl_need_worker_title',
      'category': 'jobs',
      'textKey': 'tpl_need_worker_body'
    },
    {
      'title': 'tpl_job_search_title',
      'category': 'jobs',
      'textKey': 'tpl_job_search_body'
    },
    {
      'title': 'tpl_rent_out_title',
      'category': 'rental',
      'textKey': 'tpl_rent_out_body'
    },
    {
      'title': 'tpl_rent_need_title',
      'category': 'rental',
      'textKey': 'tpl_rent_need_body'
    },
    {
      'title': 'tpl_sell_title',
      'category': 'buy_sell',
      'textKey': 'tpl_sell_body'
    },
    {
      'title': 'tpl_buy_title',
      'category': 'buy_sell',
      'textKey': 'tpl_buy_body'
    },
  ];

  final RxList<XFile> selectedImages = <XFile>[].obs;
  final RxString postText = ''.obs;

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void applyTemplate(String templateTextKey, String category) {
    final translatedText = templateTextKey.tr;
    textController.text = translatedText;
    postText.value = translatedText;
    selectedCategory.value = category;
  }

  Future<void> pickImages() async {
    // Request permissions based on Android version
    if (GetPlatform.isAndroid) {
      if (await Permission.photos.request().isGranted || 
          await Permission.storage.request().isGranted) {
        // Permission granted
      } else {
        Get.snackbar('Permission Denied', 'Please grant storage permission to select images');
        return;
      }
    }

    if (selectedImages.length >= 4) {
      Get.snackbar('Limit Reached', 'You can only select up to 4 images');
      return;
    }
    
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      // Calculate how many more we can add
      final int remaining = 4 - selectedImages.length;
      if (images.length > remaining) {
        selectedImages.addAll(images.take(remaining));
        Get.snackbar('Limit Applied', 'Only the first $remaining selected images were added to reach the limit of 4');
      } else {
        selectedImages.addAll(images);
      }
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  void handleKeyboardContent(KeyboardInsertedContent content) {
    if (selectedImages.length >= 4) {
      Get.snackbar('Limit Reached', 'You can only select up to 4 images');
      return;
    }

    // Attempt to add the keyboard content if it's a supported type
    if (content.data != null) {
       // Since it's from the keyboard, it's often a GIF or PNG
       // We can use XFile.fromData to add it to our list
       selectedImages.add(XFile.fromData(
         content.data!, 
         mimeType: content.mimeType,
         name: 'keyboard_media_${DateTime.now().millisecondsSinceEpoch}',
       ));
    } else if (content.uri.isNotEmpty) {
       // If it provides a URI (like a file path on some devices)
       selectedImages.add(XFile(content.uri, mimeType: content.mimeType));
    }
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
          final bytes = await image.readAsBytes();
          files.add(MultipartFile(bytes, filename: image.name));
        }
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
                  color: Color(0xFFE5EDFF),
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
                'post_success_title'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingSmall.copyWith(
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'post_success_desc'.tr,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF4B5563),
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
                    'done'.tr,
                    style: AppTextStyles.button.copyWith(
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

