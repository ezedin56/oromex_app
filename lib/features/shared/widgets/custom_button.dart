import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';

enum ButtonVariant { primary, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(_getLoadingColor()),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: textStyle.color),
                  const SizedBox(width: 8),
                ],
                Text(text, style: textStyle),
              ],
            ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.accentColor,
          foregroundColor: textColor ?? AppColors.primaryText,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: AppColors.accentColor.withOpacity(0.3),
        );
      case ButtonVariant.outlined:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textColor ?? AppColors.accentColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: textColor ?? AppColors.accentColor,
              width: 2,
            ),
          ),
          elevation: 0,
        );
      case ButtonVariant.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textColor ?? AppColors.accentColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        );
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = TextStyles.buttonText;

    switch (variant) {
      case ButtonVariant.primary:
        return baseStyle.copyWith(
          color: textColor ?? AppColors.primaryText,
          fontWeight: FontWeight.w600,
        );
      case ButtonVariant.outlined:
        return baseStyle.copyWith(
          color: textColor ?? AppColors.accentColor,
          fontWeight: FontWeight.w600,
        );
      case ButtonVariant.text:
        return baseStyle.copyWith(
          color: textColor ?? AppColors.accentColor,
          fontWeight: FontWeight.w600,
        );
    }
  }

  Color _getLoadingColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.primaryText;
      case ButtonVariant.outlined:
      case ButtonVariant.text:
        return AppColors.accentColor;
    }
  }
}
