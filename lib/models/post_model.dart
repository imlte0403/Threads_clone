
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

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      username: json['username'],
      isVerified: json['verified'],
      timeAgo: json['timeAgo'],
      text: json['text'],
      imageUrls: List<String>.from(json['imageUrls']),
      replies: json['replies'],
      likes: json['likes'],
      likedByAvatars: List<String>.from(json['likedByAvatars']),
    );
  }
}
