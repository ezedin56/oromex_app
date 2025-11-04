import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';

class WelcomeCard extends StatelessWidget {
  final String userName;

  const WelcomeCard({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$userName 👋',
                  style: TextStyles.headline2.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to ace your exams?',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryText.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(Icons.school, color: AppColors.primaryText, size: 30),
          ),
        ],
      ),
    );
  }
}
