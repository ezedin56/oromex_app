import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/premium_feature_card.dart';
import '../../../shared/providers/payment_provider.dart';
import '../../../shared/providers/auth_provider.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Go Premium'),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    color: AppColors.primaryText,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unlock All Features',
                    style: TextStyles.headline2.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'One-time payment • Lifetime access',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryText.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Price
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryText.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: '${AppConstants.currency} ',
                        style: TextStyles.headline3.copyWith(
                          color: AppColors.primaryText,
                        ),
                        children: [
                          TextSpan(
                            text: '${AppConstants.premiumPrice}',
                            style: TextStyles.headline1.copyWith(
                              color: AppColors.primaryText,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Features
            Text(
              'Premium Features',
              style: TextStyles.headline2.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 16),
            const PremiumFeatureCard(
              icon: Icons.lock_open,
              title: 'All Units Unlocked',
              description: 'Access all exam units beyond Unit 1',
            ),
            const SizedBox(height: 12),
            const PremiumFeatureCard(
              icon: Icons.analytics,
              title: 'Detailed Analytics',
              description: 'Track your progress with detailed statistics',
            ),
            const SizedBox(height: 12),
            const PremiumFeatureCard(
              icon: Icons.offline_bolt,
              title: 'Offline Mode',
              description: 'Download exams and practice without internet',
            ),
            const SizedBox(height: 12),
            const PremiumFeatureCard(
              icon: Icons.history,
              title: 'Performance History',
              description: 'View your complete exam history and improvements',
            ),
            const SizedBox(height: 12),
            const PremiumFeatureCard(
              icon: Icons.update,
              title: 'Lifetime Updates',
              description: 'Get all future content and feature updates',
            ),
            const SizedBox(height: 32),
            // Current Status
            if (authProvider.user?.isPremium == true)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.successColor),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.successColor,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You are a Premium User!',
                      style: TextStyles.headline3.copyWith(
                        color: AppColors.successColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enjoy all the premium features',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryText.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else if (authProvider.user?.isPaymentPending == true)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warningColor),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.pending,
                      color: AppColors.warningColor,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Payment Under Review',
                      style: TextStyles.headline3.copyWith(
                        color: AppColors.warningColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your payment is being verified. This usually takes up to 2 hours.',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryText.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              CustomButton(
                text: 'Get Premium Now',
                onPressed: () {
                  Navigator.pushNamed(context, '/payment-method');
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
