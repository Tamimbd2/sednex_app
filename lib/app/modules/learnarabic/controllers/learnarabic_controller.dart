import 'package:get/get.dart';

class LearnarabicController extends GetxController {
  final selectedTab = 0.obs;

  // Daily Life - 50 words
  final dailyLifeWords = <Map<String, String>>[
    {'bengali': 'সালাম', 'english': 'Peace', 'arabic': 'سلام', 'pronunciation': 'Salam'},
    {'bengali': 'শুভ সকাল', 'english': 'Good morning', 'arabic': 'صباح الخير', 'pronunciation': 'Sabah Al-Khair'},
    {'bengali': 'শুভ সন্ধ্যা', 'english': 'Good evening', 'arabic': 'مساء الخير', 'pronunciation': 'Masa Al-Khair'},
    {'bengali': 'ধন্যবাদ', 'english': 'Thank you', 'arabic': 'شكرا', 'pronunciation': 'Shukran'},
    {'bengali': 'দয়া করে', 'english': 'Please', 'arabic': 'من فضلك', 'pronunciation': 'Min Fadlak'},
    {'bengali': 'হ্যাঁ', 'english': 'Yes', 'arabic': 'نعم', 'pronunciation': 'Naam'},
    {'bengali': 'না', 'english': 'No', 'arabic': 'لا', 'pronunciation': 'La'},
    {'bengali': 'দুঃখিত', 'english': 'Sorry', 'arabic': 'آسف', 'pronunciation': 'Asif'},
    {'bengali': 'মাফ করবেন', 'english': 'Excuse me', 'arabic': 'معذرة', 'pronunciation': 'Maazira'},
    {'bengali': 'কেমন আছেন', 'english': 'How are you', 'arabic': 'كيف حالك؟', 'pronunciation': 'Kayfa Halak'},
    {'bengali': 'আমি ভালো আছি', 'english': 'I am fine', 'arabic': 'أنا بخير', 'pronunciation': 'Ana Bikhair'},
    {'bengali': 'আপনার নাম কী', 'english': 'What is your name', 'arabic': 'ما اسمك؟', 'pronunciation': 'Ma Ismak'},
    {'bengali': 'আমার নাম', 'english': 'My name is', 'arabic': 'اسمي', 'pronunciation': 'Ismi'},
    {'bengali': 'আপনি কোথা থেকে', 'english': 'Where are you from', 'arabic': 'من أين أنت؟', 'pronunciation': 'Min Ayna Anta'},
    {'bengali': 'আমি বাংলাদেশ থেকে', 'english': 'I am from Bangladesh', 'arabic': 'أنا من بنغلاديش', 'pronunciation': 'Ana Min Bangladesh'},
    {'bengali': 'বুঝেছি', 'english': 'I understand', 'arabic': 'فهمت', 'pronunciation': 'Fahimtu'},
    {'bengali': 'বুঝিনি', 'english': 'I don\'t understand', 'arabic': 'لم أفهم', 'pronunciation': 'Lam Afham'},
    {'bengali': 'ধীরে বলুন', 'english': 'Speak slowly', 'arabic': 'تكلم ببطء', 'pronunciation': 'Takallam Bibut'},
    {'bengali': 'আবার বলুন', 'english': 'Repeat please', 'arabic': 'أعد من فضلك', 'pronunciation': 'Aad Min Fadlak'},
    {'bengali': 'অপেক্ষা করুন', 'english': 'Wait', 'arabic': 'انتظر', 'pronunciation': 'Intazir'},
  ];

  // Work - 50 words
  final workWords = <Map<String, String>>[
    {'bengali': 'কাজ', 'english': 'Work', 'arabic': 'عمل', 'pronunciation': 'Amal'},
    {'bengali': 'চাকরি', 'english': 'Job', 'arabic': 'وظيفة', 'pronunciation': 'Wazifa'},
    {'bengali': 'ম্যানেজার', 'english': 'Manager', 'arabic': 'مدير', 'pronunciation': 'Mudir'},
    {'bengali': 'মালিক', 'english': 'Boss', 'arabic': 'صاحب العمل', 'pronunciation': 'Sahib Al-Amal'},
    {'bengali': 'বেতন', 'english': 'Salary', 'arabic': 'راتب', 'pronunciation': 'Ratib'},
    {'bengali': 'ঘন্টা', 'english': 'Hour', 'arabic': 'ساعة', 'pronunciation': 'Saa'},
    {'bengali': 'ডিউটি', 'english': 'Duty', 'arabic': 'دوام', 'pronunciation': 'Dawam'},
    {'bengali': 'ছুটি', 'english': 'Holiday', 'arabic': 'إجازة', 'pronunciation': 'Ijaza'},
    {'bengali': 'চুক্তি', 'english': 'Contract', 'arabic': 'عقد', 'pronunciation': 'Aqd'},
    {'bengali': 'সই', 'english': 'Signature', 'arabic': 'توقيع', 'pronunciation': 'Tawqi'},
    {'bengali': 'বিরতি', 'english': 'Break', 'arabic': 'استراحة', 'pronunciation': 'Istiraha'},
    {'bengali': 'দেরি', 'english': 'Delay', 'arabic': 'تأخير', 'pronunciation': 'Takhir'},
    {'bengali': 'উপস্থিতি', 'english': 'Attendance', 'arabic': 'حضور', 'pronunciation': 'Hudur'},
    {'bengali': 'অনুপস্থিতি', 'english': 'Absence', 'arabic': 'غياب', 'pronunciation': 'Ghiyab'},
    {'bengali': 'প্রশিক্ষণ', 'english': 'Training', 'arabic': 'تدريب', 'pronunciation': 'Tadrib'},
    {'bengali': 'অভিজ্ঞতা', 'english': 'Experience', 'arabic': 'خبرة', 'pronunciation': 'Khibra'},
    {'bengali': 'দক্ষতা', 'english': 'Skill', 'arabic': 'مهارة', 'pronunciation': 'Mahara'},
    {'bengali': 'দায়িত্বশীল', 'english': 'Responsible', 'arabic': 'مسؤول', 'pronunciation': 'Masul'},
    {'bengali': 'ক্লান্ত', 'english': 'Tired', 'arabic': 'تعب', 'pronunciation': 'Taab'},
    {'bengali': 'বিপদ', 'english': 'Danger', 'arabic': 'خطر', 'pronunciation': 'Khatar'},
  ];

  // Shopping - 50 words
  final shoppingWords = <Map<String, String>>[
    {'bengali': 'দাম', 'english': 'Price', 'arabic': 'سعر', 'pronunciation': 'Siar'},
    {'bengali': 'সস্তা', 'english': 'Cheap', 'arabic': 'رخيص', 'pronunciation': 'Rakhis'},
    {'bengali': 'দামী', 'english': 'Expensive', 'arabic': 'غالي', 'pronunciation': 'Ghali'},
    {'bengali': 'মূল্য', 'english': 'Cost', 'arabic': 'ثمن', 'pronunciation': 'Thaman'},
    {'bengali': 'খরচ', 'english': 'Expense', 'arabic': 'تكلفة', 'pronunciation': 'Taklifa'},
    {'bengali': 'ছাড়', 'english': 'Discount', 'arabic': 'خصم', 'pronunciation': 'Khasm'},
    {'bengali': 'ডিসকাউন্ট', 'english': 'Sale', 'arabic': 'تخفيض', 'pronunciation': 'Takhfid'},
    {'bengali': 'বিক্রি', 'english': 'Sell', 'arabic': 'بيع', 'pronunciation': 'Bay'},
    {'bengali': 'ক্রয়', 'english': 'Buy', 'arabic': 'شراء', 'pronunciation': 'Shira'},
    {'bengali': 'দোকান', 'english': 'Shop', 'arabic': 'متجر', 'pronunciation': 'Matjar'},
    {'bengali': 'বাজার', 'english': 'Market', 'arabic': 'سوق', 'pronunciation': 'Suq'},
    {'bengali': 'বিক্রেতা', 'english': 'Seller', 'arabic': 'بائع', 'pronunciation': 'Bai'},
    {'bengali': 'গ্রাহক', 'english': 'Customer', 'arabic': 'مشتري', 'pronunciation': 'Mushtari'},
    {'bengali': 'অফার', 'english': 'Offer', 'arabic': 'عرض', 'pronunciation': 'Ard'},
    {'bengali': 'ডিল', 'english': 'Deal', 'arabic': 'صفقة', 'pronunciation': 'Safqa'},
    {'bengali': 'গুণমান', 'english': 'Quality', 'arabic': 'جودة', 'pronunciation': 'Jawda'},
    {'bengali': 'সাইজ', 'english': 'Size', 'arabic': 'مقاس', 'pronunciation': 'Miqas'},
    {'bengali': 'রং', 'english': 'Color', 'arabic': 'لون', 'pronunciation': 'Lawn'},
    {'bengali': 'ধরন', 'english': 'Type', 'arabic': 'نوع', 'pronunciation': 'Naw'},
    {'bengali': 'ব্র্যান্ড', 'english': 'Brand', 'arabic': 'ماركة', 'pronunciation': 'Marka'},
  ];

  // Restaurant - 50 words
  final restaurantWords = <Map<String, String>>[
    {'bengali': 'রেস্তোরাঁ', 'english': 'Restaurant', 'arabic': 'مطعم', 'pronunciation': 'Matam'},
    {'bengali': 'মেনু', 'english': 'Menu', 'arabic': 'قائمة', 'pronunciation': 'Qaima'},
    {'bengali': 'ডিশ', 'english': 'Dish', 'arabic': 'طبق', 'pronunciation': 'Tabaq'},
    {'bengali': 'খাবার', 'english': 'Food', 'arabic': 'طعام', 'pronunciation': 'Taam'},
    {'bengali': 'পানীয়', 'english': 'Drink', 'arabic': 'شراب', 'pronunciation': 'Sharab'},
    {'bengali': 'পানি', 'english': 'Water', 'arabic': 'ماء', 'pronunciation': 'Maa'},
    {'bengali': 'জুস', 'english': 'Juice', 'arabic': 'عصير', 'pronunciation': 'Asir'},
    {'bengali': 'রুটি', 'english': 'Bread', 'arabic': 'خبز', 'pronunciation': 'Khubz'},
    {'bengali': 'মাংস', 'english': 'Meat', 'arabic': 'لحم', 'pronunciation': 'Lahm'},
    {'bengali': 'মুরগী', 'english': 'Chicken', 'arabic': 'دجاج', 'pronunciation': 'Dajaj'},
    {'bengali': 'মাছ', 'english': 'Fish', 'arabic': 'سمك', 'pronunciation': 'Samak'},
    {'bengali': 'সবজি', 'english': 'Vegetables', 'arabic': 'خضار', 'pronunciation': 'Khudar'},
    {'bengali': 'ফল', 'english': 'Fruit', 'arabic': 'فاكهة', 'pronunciation': 'Fakiha'},
    {'bengali': 'মিষ্টি', 'english': 'Dessert', 'arabic': 'حلوى', 'pronunciation': 'Halwa'},
    {'bengali': 'সুপ', 'english': 'Soup', 'arabic': 'شوربة', 'pronunciation': 'Shurba'},
    {'bengali': 'সালাদ', 'english': 'Salad', 'arabic': 'سلطة', 'pronunciation': 'Salata'},
    {'bengali': 'লবণ', 'english': 'Salt', 'arabic': 'ملح', 'pronunciation': 'Milh'},
    {'bengali': 'মরিচ', 'english': 'Pepper', 'arabic': 'فلفل', 'pronunciation': 'Filfil'},
    {'bengali': 'তেল', 'english': 'Oil', 'arabic': 'زيت', 'pronunciation': 'Zayt'},
    {'bengali': 'চিনি', 'english': 'Sugar', 'arabic': 'سكر', 'pronunciation': 'Sukkar'},
  ];

  // Transportation - 50 words
  final transportWords = <Map<String, String>>[
    {'bengali': 'পরিবহন', 'english': 'Transportation', 'arabic': 'نقل', 'pronunciation': 'Naql'},
    {'bengali': 'গাড়ি', 'english': 'Car', 'arabic': 'سيارة', 'pronunciation': 'Sayyara'},
    {'bengali': 'ট্যাক্সি', 'english': 'Taxi', 'arabic': 'تاكسي', 'pronunciation': 'Taksi'},
    {'bengali': 'বাস', 'english': 'Bus', 'arabic': 'حافلة', 'pronunciation': 'Hafila'},
    {'bengali': 'স্টেশন', 'english': 'Station', 'arabic': 'محطة', 'pronunciation': 'Mahatta'},
    {'bengali': 'বিমানবন্দর', 'english': 'Airport', 'arabic': 'مطار', 'pronunciation': 'Matar'},
    {'bengali': 'ট্রেন', 'english': 'Train', 'arabic': 'قطار', 'pronunciation': 'Qitar'},
    {'bengali': 'যাত্রা', 'english': 'Journey', 'arabic': 'رحلة', 'pronunciation': 'Rihla'},
    {'bengali': 'টিকিট', 'english': 'Ticket', 'arabic': 'تذكرة', 'pronunciation': 'Tadhkira'},
    {'bengali': 'থামার জায়গা', 'english': 'Stop', 'arabic': 'موقف', 'pronunciation': 'Mawqif'},
    {'bengali': 'রাস্তা', 'english': 'Street', 'arabic': 'شارع', 'pronunciation': 'Shari'},
    {'bengali': 'পথ', 'english': 'Road', 'arabic': 'طريق', 'pronunciation': 'Tariq'},
    {'bengali': 'সেতু', 'english': 'Bridge', 'arabic': 'جسر', 'pronunciation': 'Jisr'},
    {'bengali': 'সিগন্যাল', 'english': 'Signal', 'arabic': 'إشارة', 'pronunciation': 'Ishara'},
    {'bengali': 'রুট', 'english': 'Route', 'arabic': 'مسار', 'pronunciation': 'Masar'},
    {'bengali': 'দিক', 'english': 'Direction', 'arabic': 'اتجاه', 'pronunciation': 'Ittijah'},
    {'bengali': 'পৌঁছান', 'english': 'Arrival', 'arabic': 'وصول', 'pronunciation': 'Wusul'},
    {'bengali': 'প্রস্থান', 'english': 'Departure', 'arabic': 'مغادرة', 'pronunciation': 'Mughadara'},
    {'bengali': 'দেরি', 'english': 'Delay', 'arabic': 'تأخير', 'pronunciation': 'Takhir'},
    {'bengali': 'গতি', 'english': 'Speed', 'arabic': 'سرعة', 'pronunciation': 'Sura'},
  ];

  // Hospital - 50 words
  final hospitalWords = <Map<String, String>>[
    {'bengali': 'হাসপাতাল', 'english': 'Hospital', 'arabic': 'مستشفى', 'pronunciation': 'Mustashfa'},
    {'bengali': 'ডাক্তার', 'english': 'Doctor', 'arabic': 'طبيب', 'pronunciation': 'Tabib'},
    {'bengali': 'নার্স', 'english': 'Nurse', 'arabic': 'ممرضة', 'pronunciation': 'Mumarrida'},
    {'bengali': 'রোগী', 'english': 'Patient', 'arabic': 'مريض', 'pronunciation': 'Marid'},
    {'bengali': 'ক্লিনিক', 'english': 'Clinic', 'arabic': 'عيادة', 'pronunciation': 'Iyada'},
    {'bengali': 'অবস্থা', 'english': 'Condition', 'arabic': 'حالة', 'pronunciation': 'Hala'},
    {'bengali': 'জরুরি', 'english': 'Emergency', 'arabic': 'طوارئ', 'pronunciation': 'Tawari'},
    {'bengali': 'অ্যাম্বুলেন্স', 'english': 'Ambulance', 'arabic': 'إسعاف', 'pronunciation': 'Isaf'},
    {'bengali': 'ঔষধ', 'english': 'Medicine', 'arabic': 'دواء', 'pronunciation': 'Dawa'},
    {'bengali': 'প্রেসক্রিপশন', 'english': 'Prescription', 'arabic': 'وصفة', 'pronunciation': 'Wasfa'},
    {'bengali': 'ইনজেকশন', 'english': 'Injection', 'arabic': 'حقنة', 'pronunciation': 'Huqna'},
    {'bengali': 'পরীক্ষা', 'english': 'Test', 'arabic': 'تحليل', 'pronunciation': 'Tahlil'},
    {'bengali': 'চেকআপ', 'english': 'Checkup', 'arabic': 'فحص', 'pronunciation': 'Fahs'},
    {'bengali': 'জ্বর', 'english': 'Fever', 'arabic': 'حرارة', 'pronunciation': 'Harara'},
    {'bengali': 'ব্যথা', 'english': 'Pain', 'arabic': 'ألم', 'pronunciation': 'Alam'},
    {'bengali': 'মাথাব্যথা', 'english': 'Headache', 'arabic': 'صداع', 'pronunciation': 'Sudaa'},
    {'bengali': 'পেট ব্যথা', 'english': 'Stomach ache', 'arabic': 'مغص', 'pronunciation': 'Maghas'},
    {'bengali': 'বমি', 'english': 'Vomiting', 'arabic': 'غثيان', 'pronunciation': 'Ghathayan'},
    {'bengali': 'মাথা ঘোরা', 'english': 'Dizziness', 'arabic': 'دوار', 'pronunciation': 'Duwar'},
    {'bengali': 'কাশি', 'english': 'Cough', 'arabic': 'سعال', 'pronunciation': 'Sual'},
  ];

  // Emergency - 50 words
  final emergencyWords = <Map<String, String>>[
    {'bengali': 'জরুরি', 'english': 'Emergency', 'arabic': 'طوارئ', 'pronunciation': 'Tawari'},
    {'bengali': 'আমাকে সাহায্য করুন', 'english': 'Help me', 'arabic': 'ساعدني', 'pronunciation': 'Saidni'},
    {'bengali': 'বাঁচান', 'english': 'Save', 'arabic': 'النجدة', 'pronunciation': 'An-Najda'},
    {'bengali': 'বিপদ', 'english': 'Danger', 'arabic': 'خطر', 'pronunciation': 'Khatar'},
    {'bengali': 'আগুন', 'english': 'Fire', 'arabic': 'حريق', 'pronunciation': 'Hariq'},
    {'bengali': 'পুলিশ', 'english': 'Police', 'arabic': 'شرطة', 'pronunciation': 'Shurta'},
    {'bengali': 'অ্যাম্বুলেন্স', 'english': 'Ambulance', 'arabic': 'إسعاف', 'pronunciation': 'Isaf'},
    {'bengali': 'দুর্ঘটনা', 'english': 'Accident', 'arabic': 'حادث', 'pronunciation': 'Hadith'},
    {'bengali': 'চুরি', 'english': 'Theft', 'arabic': 'سرقة', 'pronunciation': 'Sariqa'},
    {'bengali': 'হারিয়েছি', 'english': 'Lost', 'arabic': 'فقدت', 'pronunciation': 'Faqadtu'},
    {'bengali': 'হারিয়ে গেছে', 'english': 'Missing', 'arabic': 'ضاع', 'pronunciation': 'Daa'},
    {'bengali': 'নিখোঁজ', 'english': 'Disappeared', 'arabic': 'مفقود', 'pronunciation': 'Mafqud'},
    {'bengali': 'সমস্যা', 'english': 'Problem', 'arabic': 'مشكلة', 'pronunciation': 'Mushkila'},
    {'bengali': 'জরুরি', 'english': 'Urgent', 'arabic': 'عاجل', 'pronunciation': 'Ajil'},
    {'bengali': 'দ্রুত', 'english': 'Quickly', 'arabic': 'بسرعة', 'pronunciation': 'Bisura'},
    {'bengali': 'ফোন করুন', 'english': 'Call', 'arabic': 'اتصل', 'pronunciation': 'Ittasil'},
    {'bengali': 'জরুরি নম্বর', 'english': 'Emergency number', 'arabic': 'رقم الطوارئ', 'pronunciation': 'Raqam At-Tawari'},
    {'bengali': 'আহত', 'english': 'Injured', 'arabic': 'جريح', 'pronunciation': 'Jarih'},
    {'bengali': 'রক্ত', 'english': 'Blood', 'arabic': 'دم', 'pronunciation': 'Dam'},
    {'bengali': 'ব্যথাদায়ক', 'english': 'Painful', 'arabic': 'مؤلم', 'pronunciation': 'Mulim'},
  ];

  // Documents - 50 words
  final documentsWords = <Map<String, String>>[
    {'bengali': 'পাসপোর্ট', 'english': 'Passport', 'arabic': 'جواز سفر', 'pronunciation': 'Jawaz Safar'},
    {'bengali': 'ভিসা', 'english': 'Visa', 'arabic': 'تأشيرة', 'pronunciation': 'Tashira'},
    {'bengali': 'রেসিডেন্স', 'english': 'Residence', 'arabic': 'إقامة', 'pronunciation': 'Iqama'},
    {'bengali': 'আইডি কার্ড', 'english': 'ID Card', 'arabic': 'بطاقة هوية', 'pronunciation': 'Bitaqa Hawiya'},
    {'bengali': 'ওয়ার্ক পারমিট', 'english': 'Work permit', 'arabic': 'تصريح عمل', 'pronunciation': 'Tasrih Amal'},
    {'bengali': 'চুক্তি', 'english': 'Contract', 'arabic': 'عقد', 'pronunciation': 'Aqd'},
    {'bengali': 'কপি', 'english': 'Copy', 'arabic': 'نسخة', 'pronunciation': 'Nuskha'},
    {'bengali': 'আসল', 'english': 'Original', 'arabic': 'أصل', 'pronunciation': 'Asl'},
    {'bengali': 'সই', 'english': 'Signature', 'arabic': 'توقيع', 'pronunciation': 'Tawqi'},
    {'bengali': 'সিল', 'english': 'Stamp', 'arabic': 'ختم', 'pronunciation': 'Khatm'},
    {'bengali': 'নবায়ন', 'english': 'Renewal', 'arabic': 'تجديد', 'pronunciation': 'Tajdid'},
    {'bengali': 'মেয়াদ শেষ', 'english': 'Expiry', 'arabic': 'انتهاء', 'pronunciation': 'Intiha'},
    {'bengali': 'তারিখ', 'english': 'Date', 'arabic': 'تاريخ', 'pronunciation': 'Tarikh'},
    {'bengali': 'নাম', 'english': 'Name', 'arabic': 'اسم', 'pronunciation': 'Ism'},
    {'bengali': 'নম্বর', 'english': 'Number', 'arabic': 'رقم', 'pronunciation': 'Raqam'},
    {'bengali': 'ঠিকানা', 'english': 'Address', 'arabic': 'عنوان', 'pronunciation': 'Unwan'},
    {'bengali': 'ছবি', 'english': 'Photo', 'arabic': 'صورة', 'pronunciation': 'Sura'},
    {'bengali': 'সনদ', 'english': 'Certificate', 'arabic': 'شهادة', 'pronunciation': 'Shahada'},
    {'bengali': 'জন্ম সনদ', 'english': 'Birth certificate', 'arabic': 'شهادة ميلاد', 'pronunciation': 'Shahada Milad'},
    {'bengali': 'বিবাহ সনদ', 'english': 'Marriage certificate', 'arabic': 'شهادة زواج', 'pronunciation': 'Shahada Zawaj'},
  ];

  // Banking - 50 words
  final bankingWords = <Map<String, String>>[
    {'bengali': 'ব্যাংক', 'english': 'Bank', 'arabic': 'بنك', 'pronunciation': 'Bank'},
    {'bengali': 'অ্যাকাউন্ট', 'english': 'Account', 'arabic': 'حساب', 'pronunciation': 'Hisab'},
    {'bengali': 'ব্যালেন্স', 'english': 'Balance', 'arabic': 'رصيد', 'pronunciation': 'Rasid'},
    {'bengali': 'উত্তোলন', 'english': 'Withdrawal', 'arabic': 'سحب', 'pronunciation': 'Sahb'},
    {'bengali': 'জমা', 'english': 'Deposit', 'arabic': 'إيداع', 'pronunciation': 'Ida'},
    {'bengali': 'ট্রান্সফার', 'english': 'Transfer', 'arabic': 'تحويل', 'pronunciation': 'Tahwil'},
    {'bengali': 'রেমিট্যান্স', 'english': 'Remittance', 'arabic': 'حوالة', 'pronunciation': 'Hawala'},
    {'bengali': 'কার্ড', 'english': 'Card', 'arabic': 'بطاقة', 'pronunciation': 'Bitaqa'},
    {'bengali': 'এটিএম কার্ড', 'english': 'ATM card', 'arabic': 'بطاقة صراف', 'pronunciation': 'Bitaqa Sarraf'},
    {'bengali': 'পিন', 'english': 'PIN', 'arabic': 'رقم سري', 'pronunciation': 'Raqam Sirri'},
    {'bengali': 'এটিএম', 'english': 'ATM', 'arabic': 'صراف آلي', 'pronunciation': 'Sarraf Ali'},
    {'bengali': 'চেক', 'english': 'Cheque', 'arabic': 'شيك', 'pronunciation': 'Shik'},
    {'bengali': 'কিস্তি', 'english': 'Installment', 'arabic': 'قسط', 'pronunciation': 'Qist'},
    {'bengali': 'ঋণ', 'english': 'Loan', 'arabic': 'قرض', 'pronunciation': 'Qard'},
    {'bengali': 'সুদ', 'english': 'Interest', 'arabic': 'فائدة', 'pronunciation': 'Faida'},
    {'bengali': 'কমিশন', 'english': 'Commission', 'arabic': 'عمولة', 'pronunciation': 'Umula'},
    {'bengali': 'চার্জ', 'english': 'Fee', 'arabic': 'رسوم', 'pronunciation': 'Rusum'},
    {'bengali': 'স্টেটমেন্ট', 'english': 'Statement', 'arabic': 'كشف حساب', 'pronunciation': 'Kashf Hisab'},
    {'bengali': 'নগদ', 'english': 'Cash', 'arabic': 'نقداً', 'pronunciation': 'Naqdan'},
    {'bengali': 'ডলার', 'english': 'Dollar', 'arabic': 'دولار', 'pronunciation': 'Dular'},
  ];

  // Mosque - 50 words
  final mosqueWords = <Map<String, String>>[
    {'bengali': 'মসজিদ', 'english': 'Mosque', 'arabic': 'مسجد', 'pronunciation': 'Masjid'},
    {'bengali': 'নামাজ', 'english': 'Prayer', 'arabic': 'صلاة', 'pronunciation': 'Salah'},
    {'bengali': 'আজান', 'english': 'Call to prayer', 'arabic': 'أذان', 'pronunciation': 'Adhan'},
    {'bengali': 'ইকামত', 'english': 'Second call', 'arabic': 'إقامة', 'pronunciation': 'Iqama'},
    {'bengali': 'অজু', 'english': 'Ablution', 'arabic': 'وضوء', 'pronunciation': 'Wudu'},
    {'bengali': 'জায়নামাজ', 'english': 'Prayer mat', 'arabic': 'سجادة', 'pronunciation': 'Sajjada'},
    {'bengali': 'কিবলা', 'english': 'Qibla', 'arabic': 'قبلة', 'pronunciation': 'Qibla'},
    {'bengali': 'ইমাম', 'english': 'Imam', 'arabic': 'إمام', 'pronunciation': 'Imam'},
    {'bengali': 'খুতবা', 'english': 'Sermon', 'arabic': 'خطبة', 'pronunciation': 'Khutba'},
    {'bengali': 'জুমা', 'english': 'Friday', 'arabic': 'جمعة', 'pronunciation': 'Jumua'},
    {'bengali': 'ঈদ', 'english': 'Eid', 'arabic': 'عيد', 'pronunciation': 'Eid'},
    {'bengali': 'ফজর', 'english': 'Fajr', 'arabic': 'فجر', 'pronunciation': 'Fajr'},
    {'bengali': 'যোহর', 'english': 'Dhuhr', 'arabic': 'ظهر', 'pronunciation': 'Dhuhr'},
    {'bengali': 'আসর', 'english': 'Asr', 'arabic': 'عصر', 'pronunciation': 'Asr'},
    {'bengali': 'মাগরিব', 'english': 'Maghrib', 'arabic': 'مغرب', 'pronunciation': 'Maghrib'},
    {'bengali': 'এশা', 'english': 'Isha', 'arabic': 'عشاء', 'pronunciation': 'Isha'},
    {'bengali': 'দোয়া', 'english': 'Supplication', 'arabic': 'دعاء', 'pronunciation': 'Dua'},
    {'bengali': 'কুরআন', 'english': 'Quran', 'arabic': 'قرآن', 'pronunciation': 'Quran'},
    {'bengali': 'তেলাওয়াত', 'english': 'Recitation', 'arabic': 'تلاوة', 'pronunciation': 'Tilawa'},
    {'bengali': 'জিকির', 'english': 'Remembrance', 'arabic': 'ذكر', 'pronunciation': 'Dhikr'},
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

  void changeTab(int index) {
    selectedTab.value = index;
  }

  List<Map<String, String>> getCurrentWords() {
    switch (selectedTab.value) {
      case 0:
        return dailyLifeWords;
      case 1:
        return workWords;
      case 2:
        return shoppingWords;
      case 3:
        return restaurantWords;
      case 4:
        return transportWords;
      case 5:
        return hospitalWords;
      case 6:
        return emergencyWords;
      case 7:
        return documentsWords;
      case 8:
        return bankingWords;
      case 9:
        return mosqueWords;
      default:
        return dailyLifeWords;
    }
  }
}
