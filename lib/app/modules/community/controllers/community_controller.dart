import 'package:get/get.dart';

class CommunityController extends GetxController {
  // List of all members
  final members = <Map<String, String>>[
    {
      'name': 'Mohammad Rahim',
      'location': 'Dhaka, Bangladesh',
      'image': '',
    },
    {
      'name': 'Fatema Khanam',
      'location': 'Chittagong, Bangladesh',
      'image': '',
    },
    {
      'name': 'Ahmed Hassan',
      'location': 'Sylhet, Bangladesh',
      'image': '',
    },
    {
      'name': 'Ayesha Rahman',
      'location': 'Dhaka, Bangladesh',
      'image': '',
    },
    {
      'name': 'Karim Islam',
      'location': 'Rajshahi, Bangladesh',
      'image': '',
    },
    {
      'name': 'Nusrat Jahan',
      'location': 'Khulna, Bangladesh',
      'image': '',
    },
    {
      'name': 'Rafiq Ahmed',
      'location': 'Barisal, Bangladesh',
      'image': '',
    },
    {
      'name': 'Sabina Akter',
      'location': 'Dhaka, Bangladesh',
      'image': '',
    },
    {
      'name': 'Jahangir Alam',
      'location': 'Sylhet, Bangladesh',
      'image': '',
    },
    {
      'name': 'Ruksana Begum',
      'location': 'Chittagong, Bangladesh',
      'image': '',
    },
    {
      'name': 'Nasir Uddin',
      'location': 'Dhaka, Bangladesh',
      'image': '',
    },
    {
      'name': 'Shamima Sultana',
      'location': 'Mymensingh, Bangladesh',
      'image': '',
    },
  ].obs;

  // Filtered members based on search
  final filteredMembers = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initially show all members
    filteredMembers.value = members;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Search members by name
  void searchMembers(String query) {
    if (query.isEmpty) {
      filteredMembers.value = members;
    } else {
      filteredMembers.value = members
          .where((member) =>
              member['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
