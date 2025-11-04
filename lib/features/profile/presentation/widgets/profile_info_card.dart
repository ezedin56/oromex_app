import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/providers/auth_provider.dart';

class PaymentStatusCard extends StatelessWidget {
  const PaymentStatusCard({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Status',
            style: TextStyles.headline3.copyWith(color: AppColors.primaryText),
          ),
          const SizedBox(height: 16),
          // Status Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(user?.paymentStatus).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getStatusColor(user?.paymentStatus).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(user?.paymentStatus),
                  color: _getStatusColor(user?.paymentStatus),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusTitle(user?.paymentStatus),
                        style: TextStyles.bodyLarge.copyWith(
                          color: _getStatusColor(user?.paymentStatus),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusDescription(user?.paymentStatus),
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.primaryText.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Upgrade Button for Free Users
          if (user?.isFree == true)
            CustomButton(
              text: 'Upgrade to Premium',
              onPressed: () {
                Navigator.pushNamed(context, '/premium');
              },
            ),
          // View Details Button for Pending Users
          if (user?.isPaymentPending == true)
            CustomButton(
              text: 'View Payment Details',
              variant: ButtonVariant.outlined,
              onPressed: () {
                // Navigate to payment details screen
              },
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'premium':
        return AppColors.successColor;
      case 'pending':
        return AppColors.warningColor;
      default:
        return AppColors.infoColor;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'premium':
        return Icons.verified;
      case 'pending':
        return Icons.pending;
      default:
        return Icons.info;
    }
  }

  String _getStatusTitle(String? status) {
    switch (status) {
      case 'premium':
        return 'Premium User';
      case 'pending':
        return 'Payment Under Review';
      default:
        return 'Free User';
    }
  }

  String _getStatusDescription(String? status) {
    switch (status) {
      case 'premium':
        return 'You have access to all premium features';
      case 'pending':
        return 'Your payment is being verified. This usually takes up to 2 hours.';
      default:
        return 'Upgrade to premium to unlock all features';
    }
  }
}
