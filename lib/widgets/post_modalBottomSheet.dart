import 'package:flutter/material.dart';
import '../features/report/report_screen.dart';

class PostModalBottomSheet extends StatelessWidget {
  const PostModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[100],
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Unfollow',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(height: 1, color: Colors.grey[300]),
                ListTile(
                  title: Text(
                    'Mute',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[100],
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Hide',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(height: 1, color: Colors.grey[300]),
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
