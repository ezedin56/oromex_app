class AppConstants {
  // App Info
  static const String appName = 'OROMEX';
  static const String appVersion = '4.0.0';

  // API Constants
  static const String baseUrl = 'https://api.oromex.com';
  static const int apiTimeout = 30000;

  // Security Constants
  static const int maxLoginAttempts = 5;
  static const int sessionTimeout = 30; // minutes
  static const int loginBlockDuration = 3600; // seconds (1 hour)

  // Payment Constants
  static const double premiumPrice = 300.0;
  static const String currency = 'ETB';

  // Region Constants
  static const List<String> regions = ['Oromia', 'Dire Dawa', 'Harar'];
  static const List<String> grades = ['7', '8'];
  static const List<String> languages = ['Afan Oromo', 'Amharic'];

  // Subject Constants
  static const List<String> subjects = [
    'Mathematics',
    'English',
    'Afan Oromo',
    'Amharic',
    'Science',
    'Social Studies',
    'Civic Education',
  ];

  // Social Media Links
  static const String telegramLink = 'https://t.me/oromex';
  static const String whatsappLink = 'https://wa.link/oromex';
  static const String facebookLink = 'https://facebook.com/oromex';
  static const String instagramLink = 'https://instagram.com/oromex';
  static const String tiktokLink = 'https://tiktok.com/@oromex';
  static const String emailLink = 'mailto:support@oromex.com';
}

class StorageKeys {
  static const String userData = 'user_data';
  static const String authToken = 'auth_token';
  static const String deviceFingerprint = 'device_fingerprint';
  static const String themeMode = 'theme_mode';
  static const String language = 'app_language';
  static const String examProgress = 'exam_progress';
  static const String paymentStatus = 'payment_status';
}
