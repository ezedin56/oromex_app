import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

class QuestionNavigationBar extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final Map<String, int> answers;
  final ValueChanged<int> onQuestionSelected;

  const QuestionNavigationBar({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.answers,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.secondaryBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(totalQuestions, (index) {
              final isAnswered = answers.values.length > index;
              final isCurrent = index == currentQuestionIndex;

              return _QuestionNumber(
                number: index + 1,
                isCurrent: isCurrent,
                isAnswered: isAnswered,
                onTap: () => onQuestionSelected(index),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _QuestionNumber extends StatelessWidget {
  final int number;
  final bool isCurrent;
  final bool isAnswered;
  final VoidCallback onTap;

  const _QuestionNumber({
    required this.number,
    required this.isCurrent,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (isCurrent) return AppColors.accentColor;
      if (isAnswered) return AppColors.successColor;
      return AppColors.cardBackground;
    }

    Color getTextColor() {
      if (isCurrent) return AppColors.primaryText;
      if (isAnswered) return AppColors.primaryText;
      return AppColors.primaryText.withOpacity(0.7);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrent ? AppColors.accentColor : AppColors.borderColor,
            width: isCurrent ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyles.bodyMedium.copyWith(
              color: getTextColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
