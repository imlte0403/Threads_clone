import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String username;
  final bool isVerified;
  final String timeAgo;
  final String text;
  final List<String> imageUrls;
  final int replies;
  final int likes;
  final List<String> likedByAvatars;

  PostModel({
    required this.username,
    required this.isVerified,
    required this.timeAgo,
    required this.text,
    required this.imageUrls,
    required this.replies,
    required this.likes,
    required this.likedByAvatars,
  });

  factory PostModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data() ?? {};
    final ts = m['createdAt'];
    final dt = ts is Timestamp ? ts.toDate() : null;

    return PostModel(
      username: (m['username'] ?? 'user') as String,
      isVerified: (m['isVerified'] ?? false) as bool,
      timeAgo: formatTimeAgo(dt),
      text: (m['text'] ?? (m['content'] ?? '')) as String,
      imageUrls: (m['imageUrls'] as List?)?.cast<String>() ?? const [],
      replies: (m['replies'] ?? (m['comments'] ?? 0)) as int,
      likes: (m['likes'] ?? 0) as int,
      likedByAvatars:
          (m['likedByAvatars'] as List?)?.cast<String>() ?? const [],
    );
  }
}

String formatTimeAgo(DateTime? t) {
  if (t == null) return 'now';
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'now';
  if (d.inMinutes < 60) return '${d.inMinutes}m';
  if (d.inHours < 24) return '${d.inHours}h';
  return '${d.inDays}d';
}
