import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'features/shared/providers/app_provider.dart';
import 'features/shared/providers/auth_provider.dart';
import 'features/shared/providers/theme_provider.dart';
import 'features/shared/providers/exam_provider.dart';
import 'features/shared/providers/payment_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExamProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const OromexApp(),
    ),
  );
}
