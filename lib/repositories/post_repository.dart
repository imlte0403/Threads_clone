import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../constants/firebase_constants.dart';
import '../utils/firebase_exceptions.dart';

part 'post_repository.g.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _postsCollection =>
      _firestore.collection(FirebaseConstants.postsCollection);

  // ==================== 공통 헬퍼 메서드 ====================

  /// 에러 처리가 포함된 안전한 실행
  Future<T> _safeExecute<T>(
    Future<T> Function() operation,
    String errorMessage,
  ) async {
    try {
      return await operation();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '$errorMessage: ${e.toString()}';
    }
  }

  /// 문서 리스트를 PostModel로 변환
  List<PostModel> _documentsToPostModels(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return docs.map((doc) => PostModel.fromFirestore(doc)).toList();
  }

  /// 기본 쿼리 (시간순 정렬)
  Query<Map<String, dynamic>> _baseQuery({int limit = 20}) {
    return _postsCollection
        .orderBy(FirebaseConstants.postCreatedAtField, descending: true)
        .limit(limit);
  }

  // ==================== CREATE ====================

  Future<String> createPost(PostModel post) => _safeExecute(
    () async {
      final docRef = await _postsCollection.add(post.toFirestoreForCreate());
      return docRef.id;
    },
    '게시물 작성에 실패했습니다',
  );

  Future<String> createAnonymousPost({
    required String text,
    List<String>? imageUrls,
  }) async {
    return createPost(PostModel.anonymous(text: text, imageUrls: imageUrls));
  }

  // ==================== READ ====================

  Stream<List<PostModel>> getPostsStream({int limit = 20}) {
    return _baseQuery(limit: limit)
        .snapshots()
        .map((snapshot) => _documentsToPostModels(snapshot.docs));
  }

  Future<List<PostModel>> getPosts({int limit = 20}) => _safeExecute(
    () async {
      final snapshot = await _baseQuery(limit: limit).get();
      return _documentsToPostModels(snapshot.docs);
    },
    '게시물을 불러오는데 실패했습니다',
  );

  Future<PostModel?> getPost(String postId) => _safeExecute(
    () async {
      final doc = await _postsCollection.doc(postId).get();
      return doc.exists ? PostModel.fromFirestore(doc) : null;
    },
    '게시물을 불러오는데 실패했습니다',
  );

  Future<List<PostModel>> getPostsByUser({
    required String username,
    int limit = 20,
  }) => _safeExecute(
    () async {
      final snapshot = await _postsCollection
          .where(FirebaseConstants.postUsernameField, isEqualTo: username)
          .orderBy(FirebaseConstants.postCreatedAtField, descending: true)
          .limit(limit)
          .get();
      return _documentsToPostModels(snapshot.docs);
    },
    '사용자 게시물을 불러오는데 실패했습니다',
  );

  Future<({List<PostModel> posts, DocumentSnapshot? lastDocument})> getPostsWithPagination({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) => _safeExecute(
    () async {
      var query = _baseQuery(limit: limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      
      final snapshot = await query.get();
      return (
        posts: _documentsToPostModels(snapshot.docs),
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    },
    '게시물을 불러오는데 실패했습니다',
  );

  Future<List<PostModel>> searchPosts({
    required String searchTerm,
    int limit = 20,
  }) => _safeExecute(
    () async {
      if (searchTerm.trim().isEmpty) return [];
      
      final snapshot = await _postsCollection
          .where(FirebaseConstants.postTextField, isGreaterThanOrEqualTo: searchTerm)
          .where(FirebaseConstants.postTextField, isLessThan: '${searchTerm}z')
          .orderBy(FirebaseConstants.postTextField)
          .limit(limit)
          .get();
      
      return _documentsToPostModels(snapshot.docs);
    },
    '게시물 검색에 실패했습니다',
  );

  // ==================== UPDATE ====================

  Future<void> updatePost(String postId, Map<String, dynamic> updates) => _safeExecute(
    () => _postsCollection.doc(postId).update({
      ...updates,
      FirebaseConstants.postUpdatedAtField: FieldValue.serverTimestamp(),
    }),
    '게시물 수정에 실패했습니다',
  );

  Future<void> likePost(String postId, {String? avatarUrl}) => _safeExecute(
    () {
      final updates = <String, dynamic>{
        FirebaseConstants.postLikesField: FieldValue.increment(1),
      };
      
      if (avatarUrl?.isNotEmpty ?? false) {
        updates[FirebaseConstants.postLikedByAvatarsField] = FieldValue.arrayUnion([avatarUrl]);
      }
      
      return updatePost(postId, updates);
    },
    '좋아요 처리에 실패했습니다',
  );

  Future<void> unlikePost(String postId, {String? avatarUrl}) => _safeExecute(
    () {
      final updates = <String, dynamic>{
        FirebaseConstants.postLikesField: FieldValue.increment(-1),
      };
      
      if (avatarUrl?.isNotEmpty ?? false) {
        updates[FirebaseConstants.postLikedByAvatarsField] = FieldValue.arrayRemove([avatarUrl]);
      }
      
      return updatePost(postId, updates);
    },
    '좋아요 취소 처리에 실패했습니다',
  );

  Future<void> incrementReplies(String postId) => updatePost(postId, {
    FirebaseConstants.postRepliesField: FieldValue.increment(1),
  });

  Future<void> decrementReplies(String postId) => updatePost(postId, {
    FirebaseConstants.postRepliesField: FieldValue.increment(-1),
  });

  // ==================== DELETE ====================

  Future<void> deletePost(String postId) => _safeExecute(
    () => _postsCollection.doc(postId).delete(),
    '게시물 삭제에 실패했습니다',
  );

  Future<void> deletePosts(List<String> postIds) => _safeExecute(
    () async {
      if (postIds.isEmpty) return;
      
      final batch = _firestore.batch();
      for (final postId in postIds) {
        batch.delete(_postsCollection.doc(postId));
      }
      await batch.commit();
    },
    '게시물 삭제에 실패했습니다',
  );

  // ==================== STATISTICS ====================

  Future<int> getTotalPostsCount() => _safeExecute(
    () async {
      final snapshot = await _postsCollection.count().get();
      return snapshot.count ?? 0;
    },
    '게시물 수를 가져오는데 실패했습니다',
  );

  Future<int> getUserPostsCount(String username) => _safeExecute(
    () async {
      final snapshot = await _postsCollection
          .where(FirebaseConstants.postUsernameField, isEqualTo: username)
          .count()
          .get();
      return snapshot.count ?? 0;
    },
    '사용자 게시물 수를 가져오는데 실패했습니다',
  );
}

// ==================== RIVERPOD PROVIDERS ====================

@Riverpod(keepAlive: true)
PostRepository postRepository(Ref ref) => PostRepository();

@riverpod
Stream<List<PostModel>> postsStream(Ref ref, {int limit = 20}) =>
    ref.watch(postRepositoryProvider).getPostsStream(limit: limit);

@riverpod
Future<PostModel?> post(Ref ref, String postId) =>
    ref.watch(postRepositoryProvider).getPost(postId);

@riverpod
Future<List<PostModel>> userPosts(Ref ref, String username, {int limit = 20}) =>
    ref.watch(postRepositoryProvider).getPostsByUser(username: username, limit: limit);