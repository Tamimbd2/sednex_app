import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/createpost_controller.dart';

class CreatepostView extends GetView<CreatepostController> {
  const CreatepostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFFC62828), // Deep Red
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Create Post',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Category Selection (Horizontal List)
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Obx(() {
                  final category = controller.categories[index];
                  final isSelected = controller.selectedCategory.value == category;
                  return GestureDetector(
                    onTap: () => controller.selectCategory(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4285F4) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF4285F4) : Colors.grey[300]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category.capitalizeFirst!,
                          style: GoogleFonts.inter(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          
          const SizedBox(height: 24),

          // Text Input Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller.textController,
              onChanged: (value) => controller.postText.value = value,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'What do you want to share?',
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          // Images Grid
          Expanded(
            child: Obx(() {
              if (controller.selectedImages.isEmpty) return const SizedBox.shrink();
              
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildImageGrid(),
              );
            }),
          ),

          // Bottom Action Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildActionIcon(Icons.image_outlined, 'Image', controller.pickImages), // Updated to pickImages
                const SizedBox(width: 24),
                _buildActionIcon(Icons.gif_box_outlined, 'GIF', () {}),
                const Spacer(),
                SizedBox(
                  height: 45,
                  width: 100,
                  child: Obx(() {
                    final isEnabled = (controller.postText.value.isNotEmpty || 
                                      controller.selectedImages.isNotEmpty) && !controller.isLoading.value;
                    return ElevatedButton(
                      onPressed: isEnabled ? controller.createPost : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEnabled ? const Color(0xFFDC143C) : Colors.grey[200],
                        foregroundColor: isEnabled ? Colors.white : Colors.grey[400],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: controller.isLoading.value 
                        ? const SizedBox(
                            height: 20, 
                            width: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'Post',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    final images = controller.selectedImages;
    int count = images.length;

    if (count == 1) {
      return _buildImageItem(0, height: 300);
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(child: _buildImageItem(0, height: 300)),
          const SizedBox(width: 4),
          Expanded(child: _buildImageItem(1, height: 300)),
        ],
      );
    } else if (count == 3) {
      return Column(
        children: [
          Expanded(flex: 2, child: _buildImageItem(0)),
          const SizedBox(height: 4),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(child: _buildImageItem(1)),
                const SizedBox(width: 4),
                Expanded(child: _buildImageItem(2)),
              ],
            ),
          ),
        ],
      );
    } else if (count == 4) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageItem(0)),
                const SizedBox(width: 4),
                Expanded(child: _buildImageItem(1)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageItem(2)),
                const SizedBox(width: 4),
                Expanded(child: _buildImageItem(3)),
              ],
            ),
          ),
        ],
      );
    } else {
      // 5 or more images
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageItem(0)),
                const SizedBox(width: 4),
                Expanded(child: _buildImageItem(1)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageItem(2)),
                const SizedBox(width: 4),
                Expanded(
                  child: Stack(
                    children: [
                      _buildImageItem(3),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '+${count - 3}', // Should be count - 4 actually if we display 4 items, but logic here displays 4 items total in grid
                            // Wait, logic: Items 0, 1, 2, 3. Item 3 has overlay.
                            // So we display 3 + 1(with +X).
                            // Correct math: Total 5. Display 0,1,2. Item 3 covers remaining (4, etc).
                            // So + (5-4) = +1. Correct.
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildImageItem(int index, {double? height}) {
    return Stack(
      children: [
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(controller.selectedImages[index].path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => controller.removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey[700], size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
