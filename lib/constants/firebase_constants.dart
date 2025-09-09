class FirebaseConstants {
  // Firestore Collection Names
  static const String postsCollection = 'posts';
  static const String usersCollection = 'users';
  
  // Firebase Storage Paths
  static const String postsStoragePath = 'posts';
  static const String profileImagesPath = 'profile_images';
  
  // Post Fields
  static const String postIdField = 'id';
  static const String postContentField = 'content';
  static const String postTextField = 'text';
  static const String postImageUrlsField = 'imageUrls';
  static const String postUsernameField = 'username';
  static const String postAvatarUrlField = 'avatarUrl';
  static const String postIsVerifiedField = 'isVerified';
  static const String postCreatedAtField = 'createdAt';
  static const String postUpdatedAtField = 'updatedAt';
  static const String postLikesField = 'likes';
  static const String postRepliesField = 'replies';
  static const String postLikedByAvatarsField = 'likedByAvatars';
  
  // Default Values
  static const String anonymousUsername = 'anonymous';
  static const String defaultAvatarUrl = '';
  static const bool defaultIsVerified = false;
  static const int defaultLikes = 0;
  static const int defaultReplies = 0;
  static const List<String> defaultLikedByAvatars = [];
  static const List<String> defaultImageUrls = [];
}