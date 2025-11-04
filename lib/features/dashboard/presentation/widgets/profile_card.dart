import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/providers/auth_provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: BorderRadius.circular(25),
              image: user?.profilePhoto != null
                  ? DecorationImage(
                      image: NetworkImage(user!.profilePhoto!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: user?.profilePhoto == null
                ? Icon(Icons.person, color: AppColors.primaryText, size: 24)
                : null,
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Student',
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user?.displayRegion} • Grade ${user?.grade}',
                  style: TextStyles.bodySmall.copyWith(
                    color: AppColors.primaryText.withOpacity(0.7),
                  ),
                ),
                if (user?.languageStream != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    user!.languageStream!,
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.primaryText.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Payment Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(user?.paymentStatus),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getStatusText(user?.paymentStatus),
              style: TextStyles.caption.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'premium':
        return AppColors.successColor.withOpacity(0.2);
      case 'pending':
        return AppColors.warningColor.withOpacity(0.2);
      default:
        return AppColors.infoColor.withOpacity(0.2);
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'premium':
        return 'Premium';
      case 'pending':
        return 'Pending';
      default:
        return 'Free';
    }
  }
}
