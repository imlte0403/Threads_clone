import 'package:flutter/material.dart';

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
                    print('언팔로우 클릭됨');
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
                    print('음소거 클릭됨');
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
                    print('숨기기 클릭됨');
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
                    print('신고 클릭됨');
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
