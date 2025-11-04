import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import 'custom_button.dart';

class ErrorWidget extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    required this.message,
    this.buttonText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.errorColor, size: 64),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: TextStyles.headline2.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (onRetry != null)
              CustomButton(text: buttonText ?? 'Try Again', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
