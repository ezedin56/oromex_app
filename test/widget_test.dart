import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oromex/app/app.dart';
import 'package:provider/provider.dart';
import 'package:oromex/main.dart';
import 'package:oromex/core/services/auth_service.dart';
import 'package:oromex/core/services/api_service.dart';
import 'package:oromex/core/services/local_storage.dart';
import 'package:oromex/core/services/device_binding_service.dart';
import 'package:oromex/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('App starts and shows splash screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OromexApp());

    // Verify that splash screen is shown
    expect(find.text('OROMEX'), findsOneWidget);
    expect(find.text('Past Exam Practice Platform'), findsOneWidget);
  });

  testWidgets('Login page renders correctly', (WidgetTester tester) async {
    // Create mock services
    final authService = AuthService();
    final apiService = ApiService();
    final localStorage = LocalStorage();
    final deviceBindingService = DeviceBindingService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => authService),
          Provider<ApiService>(create: (_) => apiService),
          Provider<LocalStorage>(create: (_) => localStorage),
          Provider<DeviceBindingService>(create: (_) => deviceBindingService),
        ],
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Verify that login page elements are present
    expect(find.text('OROMEX'), findsOneWidget);
    expect(find.text('Login to Your Account'), findsOneWidget);
    expect(find.byType(TextFormField),
        findsNWidgets(2)); // Email and password fields
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
  });

  testWidgets('Email validation works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    // Tap the login button without entering email
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Should show validation error
    expect(
        find.text('Please enter your email or phone number'), findsOneWidget);
  });

  testWidgets('Password validation works', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
      ),
    );

    // Enter email but not password
    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Should show password validation error
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
