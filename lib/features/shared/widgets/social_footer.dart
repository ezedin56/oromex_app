import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';

class SocialFooter extends StatelessWidget {
  const SocialFooter({super.key});

  Future<void> _launchUrl(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      print('Failed to launch URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.secondaryBackground,
      child: Column(
        children: [
          // Social Media Links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.telegram, AppConstants.telegramLink),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.chat, AppConstants.whatsappLink),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.facebook, AppConstants.facebookLink),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.camera_alt, AppConstants.instagramLink),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.music_video, AppConstants.tiktokLink),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.email, AppConstants.emailLink),
            ],
          ),
          const SizedBox(height: 16),
          // Copyright
          Text(
            '© 2025 OROMEX. All Rights Reserved.',
            style: TextStyles.caption.copyWith(
              color: AppColors.primaryText.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return IconButton(
      icon: Icon(icon),
      color: AppColors.primaryText.withOpacity(0.7),
      iconSize: 20,
      onPressed: () => _launchUrl(url),
    );
  }
}
