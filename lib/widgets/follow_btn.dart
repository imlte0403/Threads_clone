import 'package:flutter/material.dart';
import '../constants/sizes.dart';
import '../constants/text_style.dart';

class FollowButton extends StatefulWidget {
  final bool initialFollowState;
  final VoidCallback? onPressed;

  const FollowButton({
    super.key,
    this.initialFollowState = false,
    this.onPressed,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.initialFollowState;
  }

  void _handlePressed() {
    setState(() {
      isFollowing = !isFollowing;
    });
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.size96,
      height: Sizes.size32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: Sizes.size1),
        borderRadius: BorderRadius.circular(Sizes.size10),
      ),
      child: TextButton(
        onPressed: _handlePressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: AppTextStyles.followingButton,
        ),
      ),
    );
  }
}
