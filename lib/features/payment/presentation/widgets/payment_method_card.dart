import 'package:flutter/material.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../domain/models/payment_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? AppColors.accentColor.withOpacity(0.1)
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
              // Method Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getMethodColor(method.code).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getMethodIcon(method.code),
                  color: _getMethodColor(method.code),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Method Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method.description,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primaryText.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Selection Indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentColor
                        : AppColors.primaryText.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accentColor,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMethodColor(String methodCode) {
    switch (methodCode) {
      case 'cbe':
        return Colors.blue;
      case 'telebirr':
        return Colors.green;
      case 'amole':
        return Colors.orange;
      case 'hellocash':
        return Colors.purple;
      default:
        return AppColors.accentColor;
    }
  }

  IconData _getMethodIcon(String methodCode) {
    switch (methodCode) {
      case 'cbe':
        return Icons.account_balance;
      case 'telebirr':
        return Icons.phone_android;
      case 'amole':
        return Icons.credit_card;
      case 'hellocash':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }
}
