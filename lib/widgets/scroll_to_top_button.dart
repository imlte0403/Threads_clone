import 'package:flutter/material.dart';
import '../constants/sizes.dart';
import '../constants/gaps.dart';
import '../constants/app_colors.dart';

class ScrollToTopButton extends StatelessWidget {
  const ScrollToTopButton({
    super.key,
    required this.isVisible,
    required this.onTap,
  });

  final bool isVisible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: isVisible ? 1.0 : 0.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    margin: const EdgeInsets.only(top: Sizes.size12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.size25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.label(context).withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: AppColors.systemBackground(context),
                      borderRadius: BorderRadius.circular(Sizes.size25),
                      child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(Sizes.size25),
                        child: Container(
                          height: 45,
                          width: 140,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: AppColors.secondaryLabel(context),
                                size: Sizes.size20,
                              ),
                              Gaps.h4,
                              Text(
                                'TOP',
                                style: TextStyle(
                                  color: AppColors.secondaryLabel(context),
                                  fontWeight: FontWeight.w600,
                                  fontSize: Sizes.size14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}