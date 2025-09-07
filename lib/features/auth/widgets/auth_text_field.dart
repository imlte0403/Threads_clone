import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../constants/sizes.dart';
import '../../../constants/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final int? maxLines;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final bool autocorrect;
  final bool enableSuggestions;

  const AuthTextField({
    super.key,
    required this.placeholder,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction,
    this.autofocus = false,
    this.maxLines = 1,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.darkSecondarySystemBackground
                : AppColors.lightSecondarySystemBackground,
            //borderRadius: BorderRadius.circular(Sizes.size10),
            border: Border.all(
              color: _isFocused
                  ? (isDarkMode ? AppColors.darkAccent : AppColors.lightAccent)
                  : widget.errorText != null
                  ? Colors.red.shade400
                  : Colors.transparent,
              width: _isFocused ? 1.5 : 1.0,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            autofocus: widget.autofocus,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            autocorrect: widget.isPassword ? false : widget.autocorrect,
            enableSuggestions: widget.isPassword
                ? false
                : widget.enableSuggestions,
            style: TextStyle(
              fontSize: Sizes.size16,
              color: isDarkMode ? AppColors.darkLabel : AppColors.lightLabel,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                fontSize: Sizes.size16,
                color: isDarkMode
                    ? AppColors.darkTertiaryLabel.withOpacity(0.5)
                    : AppColors.lightTertiaryLabel,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.prefixIcon != null ? 0 : Sizes.size16,
                vertical: Sizes.size14,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        color: isDarkMode
                            ? AppColors.darkTertiaryLabel
                            : const Color(0xFF999999),
                        size: Sizes.size20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffixIcon,
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: Sizes.size4),
          Padding(
            padding: const EdgeInsets.only(left: Sizes.size12),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                fontSize: Sizes.size12,
                color: Colors.red.shade400,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// 이메일 전용 텍스트 필드
class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? errorText;

  const EmailTextField({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      placeholder: "Mobile number or email",
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.next,
      errorText: errorText,
      autocorrect: false,
      enableSuggestions: false,
      prefixIcon: const Icon(
        CupertinoIcons.mail,
        color: AppColors.lightTertiaryLabel,
        size: Sizes.size20,
      ),
    );
  }
}

///비밀번호 전용 텍스트 필드
class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? errorText;
  final String placeholder;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction,
    this.errorText,
    this.placeholder = "Password",
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      placeholder: placeholder,
      controller: controller,
      isPassword: true,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.done,
      errorText: errorText,
      prefixIcon: const Icon(
        CupertinoIcons.lock,
        color: AppColors.lightTertiaryLabel,
        size: Sizes.size20,
      ),
    );
  }
}
