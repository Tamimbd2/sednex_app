import 'package:flutter_test/flutter_test.dart';

// Safe Subtitle resolution logic under test
String getSubtitleText(dynamic item) {
  if (item is! Map) return '';
  
  if (item['description'] != null && item['description'].toString().isNotEmpty) {
    return item['description'].toString();
  }
  
  final content = item['content'];
  if (content is List) {
    for (var block in content) {
      if (block is Map && block['type'] == 'paragraph' && block['data'] != null) {
        return block['data'].toString();
      }
    }
  } else if (content != null) {
    return content.toString();
  }
  
  if (item['category'] != null) {
    return item['category'].toString();
  }
  
  if (item['via'] is List && (item['via'] as List).isNotEmpty) {
    return 'Via: ${(item['via'] as List).join(", ")}';
  }
  
  if (item['aboutBusServices'] != null) {
    return item['aboutBusServices'].toString();
  }
  
  return '';
}

String stripHtml(String htmlString) {
  if (htmlString.isEmpty) return '';
  return htmlString
      .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

void main() {
  group('Search View Subtitle Parsing Tests', () {
    test('Should parse string description if present', () {
      final item = {
        'description': 'This is a description',
        'content': 'Some content string'
      };
      expect(getSubtitleText(item), 'This is a description');
    });

    test('Should safely extract first paragraph from content list (Articles)', () {
      final item = {
        'content': [
          {'type': 'image', 'url': 'http://image.png'},
          {'type': 'paragraph', 'data': '<p>লেবাননে জন্ম নিবন্ধন একটি জটিল প্রক্রিয়া।</p>'}
        ]
      };
      final parsed = getSubtitleText(item);
      expect(parsed, '<p>লেবাননে জন্ম নিবন্ধন একটি জটিল প্রক্রিয়া।</p>');
      expect(stripHtml(parsed), 'লেবাননে জন্ম নিবন্ধন একটি জটিল প্রক্রিয়া।');
    });

    test('Should fallback to raw content string if it is not a list', () {
      final item = {
        'content': 'Fallback content string'
      };
      expect(getSubtitleText(item), 'Fallback content string');
    });

    test('Should fallback to category if content and description are missing', () {
      final item = {
        'category': 'General'
      };
      expect(getSubtitleText(item), 'General');
    });

    test('Should fallback to via route details for Flight Routes', () {
      final item = {
        'via': ['Dhaka', 'Beirut']
      };
      expect(getSubtitleText(item), 'Via: Dhaka, Beirut');
    });

    test('Should return empty string on empty payload without crashing', () {
      final item = {};
      expect(getSubtitleText(item), '');
    });
  });
}
