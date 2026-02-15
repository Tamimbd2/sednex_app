import 'package:get/get.dart';

class AboutusController extends GetxController {
  //TODO: Implement AboutusController

  final List<Map<String, String>> teamMembers = [
    {
      'name': 'John Smith',
      'role': 'CEO & Founder',
      'bio': 'Leading Sednex with 10+ years experience',
      'image': 'https://placehold.co/100x100'
    },
    {
      'name': 'Sarah Johnson',
      'role': 'CTO',
      'bio': 'Tech innovator & problem solver',
      'image': 'https://placehold.co/100x100'
    },
    {
      'name': 'Michael Chen',
      'role': 'Lead Designer',
      'bio': 'Creating beautiful user experiences',
      'image': 'https://placehold.co/100x100'
    },
    {
      'name': 'Emily Davis',
      'role': 'Marketing Manager',
      'bio': 'Building brands & connecting people',
      'image': 'https://placehold.co/100x100'
    },
  ];

  void openUrl(String url) {
    // Implement URL launching logic here
    print("Launching $url");
  }
}
