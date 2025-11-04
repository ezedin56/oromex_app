import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/exams/presentation/pages/exam_selection_page.dart';
import '../features/exams/presentation/pages/exam_page.dart';
import '../features/exams/presentation/pages/results_page.dart';
import '../features/payment/presentation/pages/premium_page.dart';
import '../features/payment/presentation/pages/payment_method_page.dart';
import '../features/payment/presentation/pages/payment_verification_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String examSelection = '/exam-selection';
  static const String exam = '/exam';
  static const String results = '/results';
  static const String premium = '/premium';
  static const String paymentMethod = '/payment-method';
  static const String paymentVerification = '/payment-verification';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const _SplashScreen(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      dashboard: (context) => const DashboardPage(),
      examSelection: (context) => const ExamSelectionPage(),
      exam: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return ExamPage(
          examId: args?['examId'] ?? '',
          examTitle: args?['examTitle'] ?? 'Exam',
        );
      },
      results: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return ResultsPage(examId: args?['examId'] ?? '');
      },
      premium: (context) => const PremiumPage(),
      paymentMethod: (context) => const PaymentMethodPage(),
      paymentVerification: (context) => const PaymentVerificationPage(),
      profile: (context) => const ProfilePage(),
    };
  }
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen({super.key});

  @override
  State<_SplashScreen> createState() => __SplashScreenState();
}

class __SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Check authentication status, load necessary data, etc.
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to appropriate screen
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              'OROMEX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Past Exam Practice Platform',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
