import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import 'custom_button.dart';

class RetryWidget extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onRetry;
  final IconData? icon;

  const RetryWidget({
    super.key,
    required this.message,
    required this.buttonText,
    required this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.refresh,
              color: AppColors.primaryText.withOpacity(0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: buttonText,
              onPressed: onRetry,
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }
}
