import 'package:get/get.dart';

class Embassy {
  final String name;
  final String logoPath;

  Embassy({
    required this.name,
    required this.logoPath,
  });
}

class EmbassyController extends GetxController {
  final List<Embassy> embassies = [
    Embassy(name: 'Beirut\nEmbassy', logoPath: 'assets/embassy/beirut.png'),
    Embassy(name: 'US\nEmbassy', logoPath: 'assets/embassy/us.png'),
    Embassy(name: 'Indian\nEmbassy', logoPath: 'assets/embassy/indian.png'),
    Embassy(name: 'Beirut\nEmbassy', logoPath: 'assets/embassy/beirut.png'),
    Embassy(name: 'US\nEmbassy', logoPath: 'assets/embassy/us.png'),
    Embassy(name: 'Indian\nEmbassy', logoPath: 'assets/embassy/indian.png'),
    Embassy(name: 'Beirut\nEmbassy', logoPath: 'assets/embassy/beirut.png'),
    Embassy(name: 'US\nEmbassy', logoPath: 'assets/embassy/us.png'),
    Embassy(name: 'Indian\nEmbassy', logoPath: 'assets/embassy/indian.png'),
    Embassy(name: 'Beirut\nEmbassy', logoPath: 'assets/embassy/beirut.png'),
    Embassy(name: 'US\nEmbassy', logoPath: 'assets/embassy/us.png'),
    Embassy(name: 'Indian\nEmbassy', logoPath: 'assets/embassy/indian.png'),
    Embassy(name: 'Beirut\nEmbassy', logoPath: 'assets/embassy/beirut.png'),
    Embassy(name: 'US\nEmbassy', logoPath: 'assets/embassy/us.png'),
    Embassy(name: 'Indian\nEmbassy', logoPath: 'assets/embassy/indian.png'),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
