import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../shared/widgets/custom_button.dart';

class AppUpdateDialog extends StatelessWidget {
  final bool isForceUpdate;
  final String newVersion;
  final String releaseNotes;
  final String storeUrl;

  const AppUpdateDialog({
    super.key,
    required this.isForceUpdate,
    required this.newVersion,
    required this.releaseNotes,
    required this.storeUrl,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isForceUpdate,
      child: Dialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.update, color: AppColors.accentColor, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'App Update Available',
                    style: TextStyles.headline3.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Version Info
              Text(
                'Version $newVersion is available',
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              // Release Notes
              if (releaseNotes.isNotEmpty) ...[
                Text(
                  'What\'s New:',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  releaseNotes,
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryText.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Buttons
              Row(
                children: [
                  if (!isForceUpdate)
                    Expanded(
                      child: CustomButton(
                        text: 'Later',
                        variant: ButtonVariant.outlined,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  if (!isForceUpdate) const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Update Now',
                      onPressed: () {
                        _launchStoreUrl();
                        if (!isForceUpdate) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchStoreUrl() async {
    try {
      if (await canLaunchUrl(Uri.parse(storeUrl))) {
        await launchUrl(Uri.parse(storeUrl));
      }
    } catch (e) {
      print('Failed to launch store URL: $e');
    }
  }
}
