import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../constants/sizes.dart';
import '../../../constants/gaps.dart';
import '../../../constants/app_colors.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import 'signup_view_model.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
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

    // 비밀번호 확인 검증
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = '비밀번호를 다시 입력해주세요';
      });
      isValid = false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = '비밀번호가 일치하지 않습니다';
      });
      isValid = false;
    }

    // 약관 동의 체크
    final signUpViewModel = context.read<SignUpViewModel>();
    if (!signUpViewModel.agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('서비스 약관에 동의해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      isValid = false;
    }

    return isValid;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleSignUp() async {
    if (!_validateForm()) {
      return;
    }

    final signUpViewModel = context.read<SignUpViewModel>();
    final success = await signUpViewModel.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('회원가입이 완료되었습니다. 환영합니다!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
      }
    }
  }

  void _navigateToLogin() {
    context.pop(); // 또는 context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<SignUpViewModel>(
      builder: (context, signUpViewModel, child) {
        // ViewModel
        if (signUpViewModel.isLoading != _isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isLoading = signUpViewModel.isLoading;
              });
            } 
          });
        }

        // 에러 메시지 표시
        if (signUpViewModel.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(signUpViewModel.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              signUpViewModel.clearError();
            }
          });
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: isDarkMode
                ? AppColors.darkSystemBackground
                : Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  CupertinoIcons.arrow_left,
                  color: isDarkMode
                      ? AppColors.darkLabel
                      : AppColors.lightLabel,
                ),
                onPressed: _navigateToLogin,
              ),
              title: Text(
                'Create Account',
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.darkLabel
                      : AppColors.lightLabel,
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gaps.v40,

                      // 환영 메시지
                      Text(
                        'Join Threads',
                        style: TextStyle(
                          fontSize: Sizes.size32,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode
                              ? AppColors.darkLabel
                              : AppColors.lightLabel,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Gaps.v8,

                      Text(
                        'Create your account to get started',
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          color: isDarkMode
                              ? AppColors.darkSecondaryLabel
                              : AppColors.lightSecondaryLabel,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Gaps.v40,

                      // 이메일 입력
                      AuthTextField(
                        placeholder: "Email",
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
                        textInputAction: TextInputAction.next,
                        errorText: _passwordError,
                        onSubmitted: (_) {
                          _confirmPasswordFocusNode.requestFocus();
                        },
                        onChanged: (_) {
                          if (_passwordError != null) {
                            setState(() {
                              _passwordError = null;
                            });
                          }
                        },
                      ),

                      Gaps.v16,

                      // 비밀번호 확인
                      AuthTextField(
                        placeholder: "Confirm Password",
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        errorText: _confirmPasswordError,
                        onSubmitted: (_) => _handleSignUp(),
                        onChanged: (_) {
                          if (_confirmPasswordError != null) {
                            setState(() {
                              _confirmPasswordError = null;
                            });
                          }
                        },
                      ),

                      Gaps.v24,

                      // 약관 동의
                      Row(
                        children: [
                          SizedBox(
                            width: Sizes.size24,
                            height: Sizes.size24,
                            child: Checkbox(
                              value: signUpViewModel.agreedToTerms,
                              onChanged: (value) {
                                signUpViewModel.setAgreedToTerms(
                                  value ?? false,
                                );
                              },
                              activeColor: isDarkMode
                                  ? AppColors.darkAccent
                                  : const Color(0xFF0095F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Sizes.size4,
                                ),
                              ),
                            ),
                          ),
                          Gaps.h12,
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: Sizes.size14,
                                  color: isDarkMode
                                      ? AppColors.darkSecondaryLabel
                                      : AppColors.lightSecondaryLabel,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? AppColors.darkAccent
                                          : const Color(0xFF0095F6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? AppColors.darkAccent
                                          : const Color(0xFF0095F6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Gaps.v32,

                      // 회원가입 버튼
                      AuthButton(
                        text: "Create Account",
                        onPressed: _handleSignUp,
                        isLoading: _isLoading,
                        isEnabled: !_isLoading && signUpViewModel.agreedToTerms,
                      ),

                      Gaps.v24,

                      // 구분선
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: isDarkMode
                                  ? AppColors.darkSeparator
                                  : const Color(0xFFDBDBDB),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.size16,
                            ),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                fontSize: Sizes.size14,
                                color: isDarkMode
                                    ? AppColors.darkSecondaryLabel
                                    : AppColors.lightSecondaryLabel,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: isDarkMode
                                  ? AppColors.darkSeparator
                                  : const Color(0xFFDBDBDB),
                            ),
                          ),
                        ],
                      ),

                      Gaps.v24,

                      // 로그인 링크
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: Sizes.size14,
                              color: isDarkMode
                                  ? AppColors.darkSecondaryLabel
                                  : AppColors.lightSecondaryLabel,
                            ),
                          ),
                          TextLinkButton(
                            text: 'Log in',
                            onPressed: _navigateToLogin,
                            fontSize: Sizes.size14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),

                      Gaps.v40,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
