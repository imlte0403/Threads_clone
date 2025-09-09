import 'package:flutter/material.dart';
import '../../../constants/sizes.dart';
import '../../../constants/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.height = 50.0,
    this.fontSize = Sizes.size16,
    this.fontWeight = FontWeight.w600,
    this.icon,
    this.padding,
    this.borderRadius = Sizes.size10,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 버튼 색상 결정
    final buttonColor =
        backgroundColor ??
        (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent);

    final buttonTextColor = textColor ?? Colors.white;

    // 버튼 활성화 상태
    final isButtonEnabled = isEnabled && !isLoading && onPressed != null;

    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: Sizes.size16),
        decoration: BoxDecoration(
          color: isButtonEnabled ? buttonColor : buttonColor.withAlpha(128),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: isButtonEnabled
              ? [
                  BoxShadow(
                    color: buttonColor.withAlpha(77),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: Sizes.size20,
                  height: Sizes.size20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: Sizes.size8),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: isButtonEnabled
                            ? buttonTextColor
                            : buttonTextColor.withAlpha(179),
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// 기본 로그인 버튼
class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      text: "Log in",
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }
}

/// 회원가입 버튼
class SignUpButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  const SignUpButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      text: "Create new account",
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }
}

/// 보조 버튼
class SecondaryAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final buttonBorderColor =
        borderColor ??
        (isDarkMode ? AppColors.darkSeparator : AppColors.lightSeparator);

    final buttonTextColor =
        textColor ?? (isDarkMode ? AppColors.darkLabel : AppColors.lightLabel);

    final isButtonEnabled = isEnabled && !isLoading && onPressed != null;

    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50.0,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSystemBackground : Colors.white,
          borderRadius: BorderRadius.circular(Sizes.size10),
          border: Border.all(
            color: isButtonEnabled
                ? buttonBorderColor
                : buttonBorderColor.withAlpha(128),
            width: 1.0,
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: Sizes.size20,
                  height: Sizes.size20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: Sizes.size8),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: isButtonEnabled
                            ? buttonTextColor
                            : buttonTextColor.withAlpha(128),
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// 텍스트 버튼 
class TextLinkButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const TextLinkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.fontSize = Sizes.size14,
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final linkColor =
        textColor ??
        (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent);

    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color: linkColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

/// 소셜 로그인 버튼
class SocialAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget icon;
  final bool isLoading;
  final bool isEnabled;

  const SocialAuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SecondaryAuthButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }
}
