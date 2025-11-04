import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/providers/exam_provider.dart';
import '../../domain/models/exam_session_model.dart';

class ResultsPage extends StatelessWidget {
  final String examId;

  const ResultsPage({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);
    final session = examProvider.getExamSession(examId);

    if (session == null) {
      return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Center(
          child: Text(
            'Results not found',
            style: TextStyles.bodyLarge.copyWith(color: AppColors.primaryText),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Exam Results'),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Card
            _buildScoreCard(session),
            const SizedBox(height: 24),
            // Stats
            _buildStatsCard(session),
            const SizedBox(height: 24),
            // Actions
            _buildActionButtons(context, examProvider, session),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(ExamSession session) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Exam Completed!',
            style: TextStyles.headline2.copyWith(color: AppColors.primaryText),
          ),
          const SizedBox(height: 16),
          // Score Circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: session.percentageScore / 100,
                  strokeWidth: 8,
                  backgroundColor: AppColors.primaryText.withOpacity(0.2),
                  color: _getScoreColor(session.percentageScore),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${session.percentageScore}%',
                    style: TextStyles.headline1.copyWith(
                      color: AppColors.primaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    session.status,
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryText.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${session.score}/${session.totalPoints} points',
            style: TextStyles.bodyLarge.copyWith(
              color: AppColors.primaryText.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(ExamSession session) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          _buildStatRow(
            'Correct Answers',
            '${session.correctAnswers}/${session.totalQuestions}',
          ),
          const SizedBox(height: 12),
          _buildStatRow('Time Taken', _formatTime(session.timeTaken)),
          const SizedBox(height: 12),
          _buildStatRow('Submission Reason', session.submissionReason),
          if (session.securityBreaches.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSecurityBreaches(session.securityBreaches),
          ],
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.primaryText.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityBreaches(List<String> breaches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Notices:',
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.warningColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        ...breaches.map(
          (breach) => Text(
            '• $breach',
            style: TextStyles.bodySmall.copyWith(
              color: AppColors.warningColor.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ExamProvider examProvider,
    ExamSession session,
  ) {
    return Column(
      children: [
        CustomButton(
          text: 'Review Answers',
          onPressed: () {
            // Navigate to answer review screen
          },
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Retake Exam',
          variant: ButtonVariant.outlined,
          onPressed: () {
            examProvider.resetExamSession(examId);
            Navigator.pushReplacementNamed(
              context,
              '/exam',
              arguments: {'examId': examId, 'examTitle': 'Retake Exam'},
            );
          },
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Back to Subjects',
          variant: ButtonVariant.text,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Color _getScoreColor(int percentage) {
    if (percentage >= 80) return AppColors.successColor;
    if (percentage >= 60) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }
}
