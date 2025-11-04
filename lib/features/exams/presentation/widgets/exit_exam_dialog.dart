import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../..//shared/widgets/custom_button.dart';

class ExitExamDialog extends StatelessWidget {
  final VoidCallback onExit;
  final VoidCallback onContinue;

  const ExitExamDialog({
    super.key,
    required this.onExit,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warningColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              'Exit Exam?',
              style: TextStyles.headline3.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              'Your progress will be lost if you exit the exam. Are you sure you want to exit?',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Continue Exam',
                    variant: ButtonVariant.outlined,
                    onPressed: onContinue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(text: 'Exit', onPressed: onExit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
