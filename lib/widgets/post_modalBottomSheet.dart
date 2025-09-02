import 'package:flutter/material.dart';
import '../features/report/report_screen.dart';
import '../constants/sizes.dart';
import '../constants/gaps.dart';
import '../constants/text_style.dart';
import '../constants/app_colors.dart';

class PostModalBottomSheet extends StatelessWidget {
  const PostModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.size16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.size20),
              color: AppColors.secondarySystemBackground(context),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('Unfollow', style: AppTextStyles.username(context)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(height: Sizes.size1, color: AppColors.separator(context)),
                ListTile(
                  title: Text('Mute', style: AppTextStyles.username(context)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Gaps.v10,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizes.size20),
              color: AppColors.secondarySystemBackground(context),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text('Hide', style: AppTextStyles.username(context)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(height: Sizes.size1, color: AppColors.separator(context)),
                ListTile(
                  title: Text(
                    'Report',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const ReportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
