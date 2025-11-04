import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/payment_method_card.dart';
import '../../../shared/providers/payment_provider.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String? _selectedMethod;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );
    await paymentProvider.loadPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Payment Info
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.secondaryBackground,
            child: Row(
              children: [
                Icon(Icons.payment, color: AppColors.accentColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.primaryText.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '${AppConstants.currency} ${AppConstants.premiumPrice}',
                        style: TextStyles.headline3.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Payment Methods
          Expanded(
            child: paymentProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'Choose Payment Method',
                        style: TextStyles.headline3.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...paymentProvider.paymentMethods.map((method) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PaymentMethodCard(
                            method: method,
                            isSelected: _selectedMethod == method.code,
                            onTap: () {
                              setState(() {
                                _selectedMethod = method.code;
                              });
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      // Instructions
                      if (_selectedMethod != null)
                        _buildPaymentInstructions(_selectedMethod!),
                    ],
                  ),
          ),
          // Continue Button
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.secondaryBackground,
            child: CustomButton(
              text: 'Continue to Payment',
              onPressed: _selectedMethod != null
                  ? () {
                      Navigator.pushNamed(
                        context,
                        '/payment-verification',
                        arguments: {'method': _selectedMethod!},
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInstructions(String method) {
    final instructions = _getMethodInstructions(method);

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
            'Payment Instructions',
            style: TextStyles.bodyLarge.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            instructions,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.primaryText.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'After payment, you will need to upload a screenshot of the transaction as proof.',
            style: TextStyles.bodySmall.copyWith(color: AppColors.accentColor),
          ),
        ],
      ),
    );
  }

  String _getMethodInstructions(String method) {
    switch (method) {
      case 'cbe':
        return 'Send ${AppConstants.premiumPrice} ETB to CBE Birr account number 1000 1234 5678 9012. Use your phone number as reference.';
      case 'telebirr':
        return 'Send ${AppConstants.premiumPrice} ETB to Telebirr number 0911 123 456. Use "OROMEX" as reference.';
      case 'amole':
        return 'Send ${AppConstants.premiumPrice} ETB to Amole account 2519 1234 5678. Include your username in the notes.';
      case 'hellocash':
        return 'Send ${AppConstants.premiumPrice} ETB to HelloCash number 0921 123 456. Use transaction ID as reference.';
      default:
        return 'Follow the instructions for your selected payment method.';
    }
  }
}
