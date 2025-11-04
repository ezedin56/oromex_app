import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class SecurityUtils {
  // Screen Security Methods
  static Future<void> enableScreenSecurity() async {
    try {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      print('Screen security enabled: Screenshot and screen recording disabled');
    } catch (e) {
      print('Failed to enable screen security: $e');
      throw Exception('Failed to enable screen security: $e');
    }
  }

  static Future<void> disableScreenSecurity() async {
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      print('Screen security disabled');
    } catch (e) {
      print('Failed to disable screen security: $e');
      throw Exception('Failed to disable screen security: $e');
    }
  }

  static Future<bool> isScreenSecurityEnabled() async {
    try {
      final flags = await FlutterWindowManager.getFlags();
      return (flags & FlutterWindowManager.FLAG_SECURE) != 0;
    } catch (e) {
      print('Failed to check screen security status: $e');
      return false;
    }
  }

  // Input Sanitization Methods
  static String sanitizeInput(String input) {
    if (input.isEmpty) return input;
    
    // Remove potentially dangerous characters for XSS prevention
    return input.replaceAll(RegExp(r'[<>"\'&;]'), '');
  }

  static String sanitizeHtmlInput(String input) {
    if (input.isEmpty) return input;
    
    // More aggressive sanitization for HTML content
    return input.replaceAll(RegExp(r'[<>"\'&;=/]'), '');
  }

  static String sanitizeNumericInput(String input) {
    // Only allow numbers
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static String sanitizeAlphanumericInput(String input) {
    // Only allow alphanumeric characters and basic punctuation
    return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s\-_.]'), '');
  }

  // Validation Methods
  static bool isValidTransactionReference(String ref) {
    if (ref.isEmpty) return false;
    
    // Validate transaction reference format
    final regex = RegExp(r'^[A-Za-z0-9\-_]{8,50}$');
    return regex.hasMatch(ref);
  }

  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;
    
    // Basic international phone number validation
    final regex = RegExp(r'^\+?[0-9\s\-\(\)]{10,15}$');
    return regex.hasMatch(phone);
  }

  static bool isValidPassword(String password) {
    if (password.length < 8) return false;
    
    // At least one uppercase, one lowercase, one number, one special character
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    
    return hasUpper && hasLower && hasDigit && hasSpecial;
  }

  // Data Masking Methods
  static String maskSensitiveData(String data) {
    if (data.length <= 4) return '*' * data.length;
    return '${'*' * (data.length - 4)}${data.substring(data.length - 4)}';
  }

  static String maskEmail(String email) {
    if (!isValidEmail(email)) return email;
    
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final localPart = parts[0];
    final domain = parts[1];
    
    if (localPart.length <= 2) {
      return '${'*' * localPart.length}@$domain';
    }
    
    final maskedLocal = '${localPart.substring(0, 2)}${'*' * (localPart.length - 2)}';
    return '$maskedLocal@$domain';
  }

  static String maskPhoneNumber(String phone) {
    if (phone.length <= 4) return '*' * phone.length;
    
    final cleanedPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleanedPhone.length <= 4) return '*' * cleanedPhone.length;
    
    return '${'*' * (cleanedPhone.length - 4)}${cleanedPhone.substring(cleanedPhone.length - 4)}';
  }

  static String maskCreditCard(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'[\s\-]'), '');
    if (cleaned.length != 16) return maskSensitiveData(cardNumber);
    
    return '**** **** **** ${cleaned.substring(12)}';
  }

  // Encryption Helper Methods (for basic obfuscation)
  static String simpleObfuscate(String text) {
    // Note: This is not real encryption, just basic obfuscation
    // For real encryption, use a proper encryption library like pointycastle
    final bytes = text.codeUnits;
    final obfuscated = bytes.map((byte) => byte ^ 0x42).toList();
    return String.fromCharCodes(obfuscated);
  }

  static String simpleDeobfuscate(String obfuscatedText) {
    final bytes = obfuscatedText.codeUnits;
    final original = bytes.map((byte) => byte ^ 0x42).toList();
    return String.fromCharCodes(original);
  }

  // Security Assessment
  static Map<String, dynamic> assessPasswordStrength(String password) {
    final strength = <String, dynamic>{
      'isStrong': false,
      'score': 0,
      'feedback': <String>[],
    };

    if (password.isEmpty) {
      strength['feedback'].add('Password cannot be empty');
      return strength;
    }

    // Length check
    if (password.length >= 8) strength['score'] += 1;
    else strength['feedback'].add('Password should be at least 8 characters long');

    // Upper case check
    if (RegExp(r'[A-Z]').hasMatch(password)) strength['score'] += 1;
    else strength['feedback'].add('Include at least one uppercase letter');

    // Lower case check
    if (RegExp(r'[a-z]').hasMatch(password)) strength['score'] += 1;
    else strength['feedback'].add('Include at least one lowercase letter');

    // Digit check
    if (RegExp(r'[0-9]').hasMatch(password)) strength['score'] += 1;
    else strength['feedback'].add('Include at least one number');

    // Special character check
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength['score'] += 1;
    else strength['feedback'].add('Include at least one special character');

    strength['isStrong'] = strength['score'] >= 4;

    return strength;
  }

  // Logging security events (you can integrate with your logging system)
  static void logSecurityEvent(String event, {Map<String, dynamic>? details}) {
    final timestamp = DateTime.now().toIso8601String();
    print('SECURITY EVENT [$timestamp]: $event');
    if (details != null) {
      print('Details: $details');
    }
  }
}