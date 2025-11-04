class LocalizationUtils {
  static String getSubjectName(String subject, String language) {
    // This would typically come from translation files
    final translations = {
      'en': {
        'Mathematics': 'Mathematics',
        'English': 'English',
        'Afan Oromo': 'Afan Oromo',
        'Amharic': 'Amharic',
        'Science': 'Science',
        'Social Studies': 'Social Studies',
        'Civic Education': 'Civic Education',
      },
      'am': {
        'Mathematics': 'ሒሳብ',
        'English': 'እንግሊዝኛ',
        'Afan Oromo': 'አፋን ኦሮሞ',
        'Amharic': 'አማርኛ',
        'Science': 'ሳይንስ',
        'Social Studies': 'ማህበራዊ ጥናት',
        'Civic Education': 'ዜግነት ትምህርት',
      },
    };

    return translations[language]?[subject] ?? subject;
  }

  static String getRegionName(String region, String language) {
    final translations = {
      'en': {'Oromia': 'Oromia', 'Dire Dawa': 'Dire Dawa', 'Harar': 'Harar'},
      'am': {'Oromia': 'ኦሮሚያ', 'Dire Dawa': 'ድሬዳዋ', 'Harar': 'ሐረር'},
    };

    return translations[language]?[region] ?? region;
  }

  static String getGradeName(String grade, String language) {
    return language == 'am' ? 'ክፍል $grade' : 'Grade $grade';
  }

  static String getPaymentMethodName(String method, String language) {
    final translations = {
      'en': {
        'cbe': 'CBE Birr',
        'telebirr': 'Telebirr',
        'amole': 'Amole',
        'hellocash': 'HelloCash',
      },
      'am': {
        'cbe': 'ሲቢኢ ብር',
        'telebirr': 'ቴሌብር',
        'amole': 'አሞሌ',
        'hellocash': 'ሄሎካሽ',
      },
    };

    return translations[language]?[method] ?? method;
  }
}
