import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../constants/app_data.dart';

Future<void> seedPosts({int count = 8, int repeat = 1}) async {
  final firestore = FirebaseFirestore.instance;
  final random = Random();

  final postImages = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1517849845537-4d257902454a?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1506792006437-256b665541e2?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1551632811-561732d1e306?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1444418776041-9c7e33cc5a9c?w=800&h=600&fit=crop',
    'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=600&fit=crop',
  ];

  // 유저 프로필
  final userProfiles = [
    {'username': 'doglover'},
    {'username': 'timferriss'},
    {'username': 'chefmode'},
    {'username': 'devlife'},
    {'username': 'designguru'},
    {'username': 'traveler'},
    {'username': 'photographer'},
    {'username': 'writer'},
    {'username': 'musician'},
    {'username': 'athlete'},
  ];

  // 텍스트만 있는 포스트
  final textOnlyPosts = [
    'Just finished reading an amazing book. Highly recommend it! 📚',
    'Coffee tastes better when you\'re solving complex problems ☕',
    'Tiny UI polish goes a long way.',
    'Sometimes the best solution is the simplest one.',
    'Working on something exciting. Can\'t wait to share! 🚀',
    'Great design is invisible until you notice it.',
    'Learning something new every day keeps life interesting.',
    'The journey is more important than the destination.',
    'Code review complete. Time for deployment! 💻',
    'Friday feeling: projects wrapping up nicely ✨',
  ];

  // 이미지가 포함된 포스트 텍스트
  final imagePostTexts = [
    'Photoshoot with Molly pup. :)',
    'Sketching some layout ideas.',
    'Beautiful sunset from my office window.',
    'New project mockup ready for review.',
    'Weekend hiking adventure 🏔️',
    'Fresh ingredients for tonight\'s dinner.',
    'Multiple photos from today\'s session 📸',
    'Design inspiration collection 🎨',
    'Project progress shots 📱',
    'Travel memories from last summer 🌅',
    'Food photography collection 🍕',
    'Art and design inspiration 🎭',
  ];

  // 랜덤 이미지 URL 생성 함수
  List<String> getRandomImages(int count) {
    if (count <= 0 || postImages.isEmpty) return [];
    final shuffled = List<String>.from(postImages)..shuffle(random);
    return shuffled.take(count.clamp(1, 3)).toList();
  }

  String getRandomProfileImage() {
    if (profileImages.isEmpty) return '';
    return profileImages[random.nextInt(profileImages.length)];
  }

  List<String> getRandomAvatars(int count) {
    if (count <= 0 || profileImages.isEmpty) return [];
    final shuffled = List<String>.from(profileImages)..shuffle(random);
    return shuffled.take(count.clamp(0, 4)).toList();
  }

  // 포스트 생성
  for (int r = 0; r < repeat; r++) {
    for (int i = 0; i < count; i++) {
      final hasImage = random.nextDouble() < 0.6;

      String text;
      List<String> imageUrls = [];

      if (hasImage) {
        text = imagePostTexts[random.nextInt(imagePostTexts.length)];

        // 1~3장 랜덤 선택
        final imageCount = random.nextInt(3) + 1;
        final selectedImages = getRandomImages(imageCount);

        // 빈 배열이나 잘못된 URL 방지
        if (selectedImages.isNotEmpty &&
            selectedImages.every((url) => url.isNotEmpty)) {
          imageUrls = selectedImages;
        } else {
          imageUrls = [];
        }
      } else {
        text = textOnlyPosts[random.nextInt(textOnlyPosts.length)];
        imageUrls = [];
      }

      // 좋아요 아바타
      final likedCount = random.nextInt(5);
      final selectedAvatars = getRandomAvatars(likedCount);
      final likedByAvatars = selectedAvatars
          .where((url) => url.isNotEmpty)
          .toList();

      // 유저 선택 및 랜덤 아바타 할당
      final selectedUser = userProfiles[random.nextInt(userProfiles.length)];
      final userAvatar = getRandomProfileImage();

      final post = {
        'username': selectedUser['username'] ?? 'user',
        'avatarUrl': userAvatar.isNotEmpty ? userAvatar : '',
        'isVerified': random.nextDouble() < 0.3,
        'text': text,
        'imageUrls': imageUrls,
        'replies': random.nextInt(200),
        'likes': random.nextInt(1000) + 10,
        'likedByAvatars': likedByAvatars,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await firestore.collection('posts').add(post);
    }
  }

  print('Successfully seeded ${count * repeat} posts with random images!');
}
