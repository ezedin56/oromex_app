import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../domain/models/question_model.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final int? selectedAnswer;
  final ValueChanged<int> onAnswerSelected;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.question.questionText,
              style: TextStyles.bodyLarge.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Options
          ...widget.question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = widget.selectedAnswer == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OptionCard(
                option: option,
                optionIndex: index,
                isSelected: isSelected,
                onTap: () {
                  widget.onAnswerSelected(index);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String option;
  final int optionIndex;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.option,
    required this.optionIndex,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? AppColors.accentColor.withOpacity(0.2)
          : AppColors.cardBackground,
      elevation: isSelected ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.accentColor : AppColors.borderColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Option Letter
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentColor
                      : AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + optionIndex), // A, B, C, D
                    style: TextStyles.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.primaryText
                          : AppColors.primaryText.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Option Text
              Expanded(
                child: Text(
                  option,
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              // Selection Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.accentColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
