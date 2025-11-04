import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/providers/payment_provider.dart';

class PaymentVerificationPage extends StatefulWidget {
  const PaymentVerificationPage({super.key});

  @override
  State<PaymentVerificationPage> createState() =>
      _PaymentVerificationPageState();
}

class _PaymentVerificationPageState extends State<PaymentVerificationPage> {
  final _transactionRefController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  void _initializePayment() {
    final paymentProvider = Provider.of<PaymentProvider>(
      context,
      listen: false,
    );
    paymentProvider.initiatePayment(
      AppConstants.premiumPrice,
      _getPaymentMethod(),
    );
  }

  String _getPaymentMethod() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    return args?['method'] ?? 'telebirr';
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _submitPayment() async {
    if (_transactionRefController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter transaction reference')),
      );
      return;
    }

    if (_selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload payment proof')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final paymentProvider = Provider.of<PaymentProvider>(
        context,
        listen: false,
      );
      await paymentProvider.submitPaymentProof(
        _transactionRefController.text,
        _selectedImagePath!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment proof submitted successfully')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit payment: $e')));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Payment Verification'),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount:',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryText.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '${AppConstants.currency} ${AppConstants.premiumPrice}',
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Method:',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryText.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        _getPaymentMethod().toUpperCase(),
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Transaction Reference
            Text(
              'Transaction Reference',
              style: TextStyles.headline3.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _transactionRefController,
              decoration: InputDecoration(
                hintText: 'Enter transaction reference number',
                hintStyle: TextStyle(
                  color: AppColors.primaryText.withOpacity(0.5),
                ),
                filled: true,
                fillColor: AppColors.secondaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: AppColors.primaryText),
            ),
            const SizedBox(height: 24),
            // Payment Proof Upload
            Text(
              'Payment Proof',
              style: TextStyles.headline3.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload a screenshot of your payment confirmation',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.primaryText.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            // Image Upload Area
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderColor,
                  style: _selectedImagePath == null
                      ? BorderStyle.solid
                      : BorderStyle.none,
                ),
              ),
              child: _selectedImagePath == null
                  ? InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload,
                            color: AppColors.primaryText.withOpacity(0.5),
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to upload screenshot',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryText.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            _selectedImagePath!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryBackground.withOpacity(
                                0.8,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              color: AppColors.primaryText,
                              onPressed: () {
                                setState(() {
                                  _selectedImagePath = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supported formats: JPG, PNG (Max: 2MB)',
              style: TextStyles.caption.copyWith(
                color: AppColors.primaryText.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 32),
            // Submit Button

            // Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: AppColors.infoColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your payment will be verified within 2 hours. You will receive a notification once approved.',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.infoColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _transactionRefController.dispose();
    super.dispose();
  }
}
