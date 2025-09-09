import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firebase_constants.dart';

class PostModel {
  final String? id;
  final String username;
  final String? avatarUrl;
  final bool isVerified;
  final String text;
  final List<String> imageUrls;
  final int replies;
  final int likes;
  final List<String> likedByAvatars;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PostModel({
    this.id,
    required this.username,
    this.avatarUrl,
    this.isVerified = FirebaseConstants.defaultIsVerified,
    required this.text,
    this.imageUrls = FirebaseConstants.defaultImageUrls,
    this.replies = FirebaseConstants.defaultReplies,
    this.likes = FirebaseConstants.defaultLikes,
    this.likedByAvatars = FirebaseConstants.defaultLikedByAvatars,
    this.createdAt,
    this.updatedAt,
  });

  // 익명 사용자용 생성자
  factory PostModel.anonymous({
    String? id,
    required String text,
    List<String>? imageUrls,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id,
      username: FirebaseConstants.anonymousUsername,
      avatarUrl: FirebaseConstants.defaultAvatarUrl,
      isVerified: FirebaseConstants.defaultIsVerified,
      text: text,
      imageUrls: imageUrls ?? FirebaseConstants.defaultImageUrls,
      replies: FirebaseConstants.defaultReplies,
      likes: FirebaseConstants.defaultLikes,
      likedByAvatars: FirebaseConstants.defaultLikedByAvatars,
      createdAt: createdAt,
    );
  }

  // Firestore 문서로부터 생성
  factory PostModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    
    return PostModel(
      id: doc.id,
      username: _getString(data, FirebaseConstants.postUsernameField, FirebaseConstants.anonymousUsername)!,
      avatarUrl: _getString(data, FirebaseConstants.postAvatarUrlField, FirebaseConstants.defaultAvatarUrl),
      isVerified: _getBool(data, FirebaseConstants.postIsVerifiedField, FirebaseConstants.defaultIsVerified),
      text: _getString(data, FirebaseConstants.postTextField) ?? 
            _getString(data, FirebaseConstants.postContentField) ?? '',
      imageUrls: _getStringList(data, FirebaseConstants.postImageUrlsField),
      replies: _getInt(data, FirebaseConstants.postRepliesField, FirebaseConstants.defaultReplies),
      likes: _getInt(data, FirebaseConstants.postLikesField, FirebaseConstants.defaultLikes),
      likedByAvatars: _getStringList(data, FirebaseConstants.postLikedByAvatarsField),
      createdAt: _getDateTime(data, FirebaseConstants.postCreatedAtField),
      updatedAt: _getDateTime(data, FirebaseConstants.postUpdatedAtField),
    );
  }

  // Firestore에 저장하기 위한 Map 변환
  Map<String, dynamic> toFirestore() {
    return {
      FirebaseConstants.postUsernameField: username,
      FirebaseConstants.postAvatarUrlField: avatarUrl ?? FirebaseConstants.defaultAvatarUrl,
      FirebaseConstants.postIsVerifiedField: isVerified,
      FirebaseConstants.postTextField: text,
      FirebaseConstants.postImageUrlsField: imageUrls,
      FirebaseConstants.postRepliesField: replies,
      FirebaseConstants.postLikesField: likes,
      FirebaseConstants.postLikedByAvatarsField: likedByAvatars,
      if (createdAt != null) FirebaseConstants.postCreatedAtField: Timestamp.fromDate(createdAt!),
      if (updatedAt != null) FirebaseConstants.postUpdatedAtField: Timestamp.fromDate(updatedAt!),
    };
  }

  // 새 게시물 생성용 (서버 타임스탬프 사용)
  Map<String, dynamic> toFirestoreForCreate() {
    return {
      FirebaseConstants.postUsernameField: username,
      FirebaseConstants.postAvatarUrlField: avatarUrl ?? FirebaseConstants.defaultAvatarUrl,
      FirebaseConstants.postIsVerifiedField: isVerified,
      FirebaseConstants.postTextField: text,
      FirebaseConstants.postImageUrlsField: imageUrls,
      FirebaseConstants.postRepliesField: replies,
      FirebaseConstants.postLikesField: likes,
      FirebaseConstants.postLikedByAvatarsField: likedByAvatars,
      FirebaseConstants.postCreatedAtField: FieldValue.serverTimestamp(),
      FirebaseConstants.postUpdatedAtField: FieldValue.serverTimestamp(),
    };
  }

  // 시간 표시를 위한 getter
  String get timeAgo => formatTimeAgo(createdAt);

  // 익명 사용자인지 확인
  bool get isAnonymous => username == FirebaseConstants.anonymousUsername;

  // 이미지가 있는지 확인
  bool get hasImages => imageUrls.isNotEmpty;

  // copyWith 메서드
  PostModel copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    bool? isVerified,
    String? text,
    List<String>? imageUrls,
    int? replies,
    int? likes,
    List<String>? likedByAvatars,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      text: text ?? this.text,
      imageUrls: imageUrls ?? this.imageUrls,
      replies: replies ?? this.replies,
      likes: likes ?? this.likes,
      likedByAvatars: likedByAvatars ?? this.likedByAvatars,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostModel &&
        other.id == id &&
        other.username == username &&
        other.text == text &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode ^ text.hashCode ^ createdAt.hashCode;
  }

  @override
  String toString() {
    return 'PostModel(id: $id, username: $username, text: $text, createdAt: $createdAt)';
  }

  // Helper methods for data extraction
  static String? _getString(Map<String, dynamic> data, String key, [String? defaultValue]) {
    final value = data[key];
    if (value == null) return defaultValue;
    return value is String ? value : defaultValue;
  }

  static bool _getBool(Map<String, dynamic> data, String key, bool defaultValue) {
    final value = data[key];
    return value is bool ? value : defaultValue;
  }

  static int _getInt(Map<String, dynamic> data, String key, int defaultValue) {
    final value = data[key];
    return value is int ? value : defaultValue;
  }

  static List<String> _getStringList(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  static DateTime? _getDateTime(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is Timestamp) {
      return value.toDate();
    }
    return null;
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
