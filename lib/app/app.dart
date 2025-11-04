import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'routes.dart';
import 'theme/app_theme.dart';
import '../features/shared/providers/theme_provider.dart';
import '../features/shared/providers/auth_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class OromexApp extends StatelessWidget {
  const OromexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'OROMEX',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.routes,
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          supportedLocales: const [Locale('en', ''), Locale('am', '')],
          localizationsDelegates: const [
            // AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
