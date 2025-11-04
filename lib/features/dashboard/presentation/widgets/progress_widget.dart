import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/providers/exam_provider.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);
    final progress = examProvider.userProgress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Progress',
                style: TextStyles.headline3.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              Icon(Icons.analytics, color: AppColors.accentColor),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Stats
          Row(
            children: [
              _buildStatItem(
                'Exams Taken',
                '${progress.examsTaken}',
                Icons.assignment_turned_in,
              ),
              const SizedBox(width: 20),
              _buildStatItem(
                'Average Score',
                '${progress.averageScore}%',
                Icons.trending_up,
              ),
              const SizedBox(width: 20),
              _buildStatItem(
                'Last 7 Days',
                '${progress.examsLast7Days}',
                Icons.calendar_today,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Continue Last Exam Button
          if (progress.lastExamInProgress != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.accentColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: AppColors.accentColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Continue Your Last Exam',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          progress.lastExamInProgress!,
                          style: TextStyles.bodySmall.copyWith(
                            color: AppColors.primaryText.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.accentColor,
                    size: 16,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: AppColors.accentColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyles.headline3.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyles.caption.copyWith(
              color: AppColors.primaryText.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
