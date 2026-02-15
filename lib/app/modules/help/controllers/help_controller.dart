import 'package:get/get.dart';

class HelpController extends GetxController {
  //TODO: Implement HelpController

  final faqs = <Map<String, dynamic>>[
    {
      'question': 'How do I create an account?',
      'answer': 'To create an account, click on the \'Sign Up\' button on the home page. Fill in your email, create a password, and verify your email address. Once verified, you can start using all features.',
      'isExpanded': true.obs,
    },
    {
      'question': 'How can I reset my password?',
      'answer': 'Go to the login page and click "Forgot Password". Follow the instructions sent to your email to reset it.',
      'isExpanded': false.obs,
    },
    {
      'question': 'Is my data secure?',
      'answer': 'Yes, we use industry-standard encryption to protect your personal data and ensure your privacy.',
      'isExpanded': false.obs,
    },
    {
      'question': 'How do I contact customer support?',
      'answer': 'You can contact us via the "Contact Support" button below or email us directly at support@sednex.com.',
      'isExpanded': false.obs,
    },
    {
      'question': 'Can I use the app offline?',
      'answer': 'Some features are available offline, but you will need an internet connection for most functionalities.',
      'isExpanded': false.obs,
    },
    {
      'question': 'How do I delete my account?',
      'answer': 'Please contact our support team to request account deletion. We will process your request within 48 hours.',
      'isExpanded': false.obs,
    },
    {
      'question': 'What payment methods do you accept?',
      'answer': 'We accept major credit cards, debit cards, and secure online payment gateways.',
      'isExpanded': false.obs,
    },
    {
      'question': 'How can I update my profile information?',
      'answer': 'Go to your Profile page and click "Edit Profile" to update your personal details.',
      'isExpanded': false.obs,
    },
  ].obs;

  void toggleFaq(int index) {
    faqs[index]['isExpanded'].value = !faqs[index]['isExpanded'].value;
  }

  void contactSupport() {
    // Implement contact support logic
    print("Contact Support Clicked");
  }
}
