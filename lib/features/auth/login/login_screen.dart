import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../constants/sizes.dart';
import '../../../constants/gaps.dart';
import '../../../constants/app_colors.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import 'login_view_model.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  
  final bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool isValid = true;

    // 이메일 검증
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = '이메일을 입력해주세요';
      });
      isValid = false;
    } else if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _emailError = '올바른 이메일 형식이 아닙니다';
      });
      isValid = false;
    }

    // 비밀번호 검증
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = '비밀번호를 입력해주세요';
      });
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = '비밀번호는 6자 이상이어야 합니다';
      });
      isValid = false;
    }

    return isValid;
  }
  // 이메일 검증
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleLogin() async {
    if (!_validateForm()) return;

    final loginViewModel = context.read<LoginViewModel>();
    
    final success = await loginViewModel.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success) {
      if (mounted) {
        context.go('/');
      }
    } else {
    }
  }

  void _navigateToSignUp() {
    context.push('/signup');
  }

  void _navigateToForgotPassword() {
    // TODO: 비밀번호 찾기 화면으로 이동
    // context.push('/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDarkMode 
            ? AppColors.darkSystemBackground 
            : Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Gaps.v80,
                  
                  // 언어 선택
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'English (US)',
                        style: TextStyle(
                          color: isDarkMode 
                              ? AppColors.darkSecondaryLabel 
                              : AppColors.lightSecondaryLabel,
                          fontSize: Sizes.size14,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: Sizes.size20,
                        color: AppColors.lightSecondaryLabel,
                      ),
                    ],
                  ),
                  
                  Gaps.v60,
                  
                  // Threads 로고
                  Center(
                    child: Image.asset(
                      isDarkMode 
                          ? 'assets/Threads-Logo-white.png'
                          : 'assets/Threads-Logo.png',
                      width: Sizes.size80,
                      height: Sizes.size80,
                    ),
                  ),
                  
                  Gaps.v80,
                  
                  // 이메일 입력
                  AuthTextField(
                    placeholder: "Mobile number or email",
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    errorText: _emailError,
                    onSubmitted: (_) {
                      _passwordFocusNode.requestFocus();
                    },
                    onChanged: (_) {
                      if (_emailError != null) {
                        setState(() {
                          _emailError = null;
                        });
                      }
                    },
                  ),
                  
                  Gaps.v16,
                  
                  // 비밀번호 입력
                  AuthTextField(
                    placeholder: "Password",
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    errorText: _passwordError,
                    onSubmitted: (_) => _handleLogin(),
                    onChanged: (_) {
                      if (_passwordError != null) {
                        setState(() {
                          _passwordError = null;
                        });
                      }
                    },
                  ),
                  
                  Gaps.v24,
                  
                  // 로그인 버튼
                  AuthButton(
                    text: "Log in",
                    onPressed: _handleLogin,
                    isLoading: _isLoading,
                    isEnabled: !_isLoading,
                  ),
                  
                  Gaps.v16,
                  
                  // 비밀번호 찾기
                  Center(
                    child: TextLinkButton(
                      text: "Forgot password?",
                      onPressed: _navigateToForgotPassword,
                    ),
                  ),
                  
                  Gaps.v80,
                  
                  // 회원가입 버튼
                  SecondaryAuthButton(
                    text: "Create new account",
                    onPressed: _navigateToSignUp,
                    isEnabled: !_isLoading,
                  ),
                  
                  Gaps.v40,
                  
                  // Meta 로고
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.infinite,
                          size: Sizes.size28,
                          color: isDarkMode 
                              ? AppColors.darkSecondaryLabel 
                              : AppColors.lightSecondaryLabel,
                        ),
                        Gaps.h8,
                        Text(
                          'Meta',
                          style: TextStyle(
                            color: isDarkMode 
                                ? AppColors.darkSecondaryLabel 
                                : AppColors.lightSecondaryLabel,
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Gaps.v20,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}