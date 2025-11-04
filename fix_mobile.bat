@echo off
echo Fixing Flutter mobile app...

:: Create directories
mkdir lib\shared\widgets 2>nul
mkdir lib\features\shared\providers 2>nul
mkdir lib\features\payment\domain\models 2>nul

:: Create CustomButton widget
(
echo import 'package:flutter/material.dart';^
echo^
echo enum ButtonVariant { primary, secondary, outlined, text }^
echo^
echo class CustomButton extends StatelessWidget {^
echo   final String text;^
echo   final VoidCallback? onPressed;^
echo   final ButtonVariant variant;^
echo   final bool isLoading;^
echo^
echo   const CustomButton({^
echo     Key? key,^
echo     required this.text,^
echo     required this.onPressed,^
echo     this.variant = ButtonVariant.primary,^
echo     this.isLoading = false,^
echo   ^}) : super^(key: key^);^
echo^
echo   @override^
echo   Widget build^(BuildContext context^) {^
echo     final buttonStyle = _getButtonStyle^(context^);^
echo     return ElevatedButton(^
echo       onPressed: isLoading ? null : onPressed,^
echo       style: buttonStyle,^
echo       child: isLoading^
echo           ? SizedBox(^
echo               width: 20,^
echo               height: 20,^
echo               child: CircularProgressIndicator(^
echo                 strokeWidth: 2,^
echo               ^),^
echo             ^)^
echo           : Text(^
echo               text,^
echo               style: TextStyle(^
echo                 fontSize: 16,^
echo                 fontWeight: FontWeight.w600,^
echo               ^),^
echo             ^),^
echo     ^);^
echo   ^}^
echo^
echo   ButtonStyle _getButtonStyle^(BuildContext context^) {^
echo     switch ^(variant^) {^
echo       case ButtonVariant.primary:^
echo         return ElevatedButton.styleFrom(^
echo           backgroundColor: Theme.of^(context^).primaryColor,^
echo           foregroundColor: Colors.white,^
echo           padding: EdgeInsets.symmetric^(vertical: 16, horizontal: 24^),^
echo         ^);^
echo       case ButtonVariant.secondary:^
echo         return ElevatedButton.styleFrom(^
echo           backgroundColor: Colors.grey[300],^
echo           foregroundColor: Colors.black,^
echo           padding: EdgeInsets.symmetric^(vertical: 16, horizontal: 24^),^
echo         ^);^
echo       case ButtonVariant.outlined:^
echo         return ElevatedButton.styleFrom(^
echo           backgroundColor: Colors.transparent,^
echo           foregroundColor: Theme.of^(context^).primaryColor,^
echo           side: BorderSide^(color: Theme.of^(context^).primaryColor^),^
echo           padding: EdgeInsets.symmetric^(vertical: 16, horizontal: 24^),^
echo         ^);^
echo       case ButtonVariant.text:^
echo         return ElevatedButton.styleFrom(^
echo           backgroundColor: Colors.transparent,^
echo           foregroundColor: Theme.of^(context^).primaryColor,^
echo           padding: EdgeInsets.symmetric^(vertical: 16, horizontal: 24^),^
echo         ^);^
echo     ^}^
echo   ^}^
echo ^}^
) > lib\shared\widgets\custom_button.dart

:: Create ExamProvider
(
echo import 'package:flutter/foundation.dart';^
echo^
echo class ExamProvider with ChangeNotifier {^
echo   int _currentQuestionIndex = 0;^
echo   int _totalQuestions = 0;^
echo^
echo   int get currentQuestionIndex => _currentQuestionIndex;^
echo   int get totalQuestions => _totalQuestions;^
echo^
echo   void nextQuestion^(^) {^
echo     if ^(_currentQuestionIndex ^< _totalQuestions - 1^) {^
echo       _currentQuestionIndex++;^
echo       notifyListeners^(^);^
echo     ^}^
echo   ^}^
echo^
echo   void previousQuestion^(^) {^
echo     if ^(_currentQuestionIndex ^> 0^) {^
echo       _currentQuestionIndex--;^
echo       notifyListeners^(^);^
echo     ^}^
echo   ^}^
echo^
echo   void setTotalQuestions^(int total^) {^
echo     _totalQuestions = total;^
echo     notifyListeners^(^);^
echo   ^}^
echo^
echo   void reset^(^) {^
echo     _currentQuestionIndex = 0;^
echo     notifyListeners^(^);^
echo   ^}^
echo ^}^
) > lib\features\shared\providers\exam_provider.dart

:: Create PaymentModel
(
echo enum PaymentMethod {^
echo   creditCard,^
echo   mobileMoney,^
echo   bankTransfer,^
echo ^}^
echo^
echo class PaymentModel {^
echo   final String id;^
echo   final double amount;^
echo   final PaymentMethod method;^
echo   final DateTime date;^
echo^
echo   PaymentModel(^
echo     required this.id,^
echo     required this.amount,^
echo     required this.method,^
echo     required this.date,^
echo   ^);^
echo ^}^
) > lib\features\payment\domain\models\payment_model.dart

echo ✅ Missing files created!
echo.
echo Now running Flutter clean and pub get...
flutter clean
flutter pub get

echo.
echo 📱 Ready to run on mobile!
echo Use: flutter run -d android
pause