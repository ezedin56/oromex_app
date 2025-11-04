import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/widgets/custom_button.dart';

class SecurityWarningDialog extends StatelessWidget {
  const SecurityWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.security, color: AppColors.accentColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Exam Security Notice',
                  style: TextStyles.headline3.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Security Points
            _buildSecurityPoint(
              'Screenshots and screen recording are disabled during this exam',
            ),
            const SizedBox(height: 12),
            _buildSecurityPoint(
              'Switching to another app will automatically submit your exam',
            ),
            const SizedBox(height: 12),
            _buildSecurityPoint(
              'Questions and answers are randomized for each attempt',
            ),
            const SizedBox(height: 20),
            // Warning Text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warningColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                'Please ensure you have uninterrupted time before starting the exam.',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.warningColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    variant: ButtonVariant.outlined,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'I Understand',
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: AppColors.successColor, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.primaryText.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
