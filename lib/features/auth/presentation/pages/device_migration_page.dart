import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/colors.dart';
import '../../../../app/theme/text_styles.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/providers/auth_provider.dart';

class DeviceMigrationPage extends StatelessWidget {
  const DeviceMigrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Warning Icon
              Icon(Icons.device_unknown, color: AppColors.errorColor, size: 80),
              const SizedBox(height: 24),
              // Title
              Text(
                'Device Access Issue',
                style: TextStyles.headline2.copyWith(
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                'This account is registered on another device. For security reasons, each account can only be used on one device.',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryText.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Options
              _buildMigrationOptions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMigrationOptions(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        if (authProvider.isLoading)
          const LoadingIndicator()
        else
          CustomButton(
            text: 'Request Device Migration',
            onPressed: () {
              _showMigrationDialog(context);
            },
          ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Contact Support',
          variant: ButtonVariant.outlined,
          onPressed: () {
            _contactSupport();
          },
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Logout',
          variant: ButtonVariant.text,
          onPressed: () {
            authProvider.logout();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  void _showMigrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Device Migration Request'),
        content: const Text(
          'A request will be sent to our support team to migrate your account to this device. '
          'This process may take up to 24 hours. You will receive a notification once approved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _submitMigrationRequest(context);
            },
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  void _submitMigrationRequest(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.requestDeviceMigration();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Migration request submitted successfully'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit request: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _contactSupport() {
    // Implement contact support functionality
    // This could open email, WhatsApp, or other communication channels
  }
}
