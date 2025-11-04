import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/providers/auth_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await context.read<AuthProvider>().forgotPassword(
              _emailController.text.trim(),
            );
        setState(() {
          _emailSent = true;
        });
      } catch (e) {
        // Error is handled by the provider
      }
    }
  }

  Future<void> _handleResendEmail() async {
    try {
      await context.read<AuthProvider>().forgotPassword(
            _emailController.text.trim(),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Reset instructions sent again'),
          backgroundColor: AppColors.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      // Error handled by provider
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Illustration/Icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      color: AppColors.accentColor,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  'Reset Your Password',
                  style: TextStyles.headline2.copyWith(
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _emailSent
                      ? 'Check your email for reset instructions'
                      : 'Enter your email to receive reset instructions',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                if (!_emailSent) ...[
                  TextFormField(
                    controller: _emailController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        color: AppColors.primaryText.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppColors.primaryText.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: AppColors.secondaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: TextStyle(color: AppColors.primaryText),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      final trimmedValue = value.trim();
                      if (trimmedValue.isEmpty) {
                        return 'Please enter a valid email address';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(trimmedValue)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _handleResetPassword(),
                  ),
                  const SizedBox(height: 24),
                  if (authProvider.isLoading)
                    const LoadingIndicator()
                  else
                    CustomButton(
                      text: 'Send Reset Instructions',
                      onPressed: _handleResetPassword,
                    ),
                ] else ...[
                  // Success State
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.successColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.successColor,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Email Sent Successfully',
                          style: TextStyles.headline3.copyWith(
                            color: AppColors.successColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We have sent password reset instructions to ${_emailController.text}. Please check your email and follow the instructions.',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryText.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'If you don\'t see the email, check your spam folder.',
                          style: TextStyles.bodySmall.copyWith(
                            color: AppColors.primaryText.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Back to Login',
                          variant: ButtonVariant.outlined,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: 'Resend Email',
                          onPressed: _handleResendEmail,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                // Additional help text
                if (!_emailSent)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Remember your password? Sign in',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.accentColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
