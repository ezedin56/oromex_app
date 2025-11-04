import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../domain/models/exam_model.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback onTap;

  const ExamCard({super.key, required this.exam, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Exam Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getSubjectColor(exam.subject).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getSubjectIcon(exam.subject),
                  color: _getSubjectColor(exam.subject),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Exam Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.displayTitle,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exam.displayInfo,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primaryText.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${exam.region} • ${exam.languageStream}',
                      style: TextStyles.caption.copyWith(
                        color: AppColors.primaryText.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              // Access Badge
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: exam.isAccessible
                          ? AppColors.successColor.withOpacity(0.2)
                          : AppColors.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      exam.isAccessible ? 'Free' : 'Premium',
                      style: TextStyles.caption.copyWith(
                        color: exam.isAccessible
                            ? AppColors.successColor
                            : AppColors.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primaryText.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Mathematics':
        return Colors.blue;
      case 'English':
        return Colors.green;
      case 'Afan Oromo':
        return Colors.orange;
      case 'Amharic':
        return Colors.purple;
      case 'Science':
        return Colors.red;
      case 'Social Studies':
        return Colors.brown;
      case 'Civic Education':
        return Colors.teal;
      default:
        return AppColors.accentColor;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Mathematics':
        return Icons.calculate;
      case 'English':
        return Icons.language;
      case 'Afan Oromo':
      case 'Amharic':
        return Icons.translate;
      case 'Science':
        return Icons.science;
      case 'Social Studies':
        return Icons.public;
      case 'Civic Education':
        return Icons.account_balance;
      default:
        return Icons.school;
    }
  }
}
