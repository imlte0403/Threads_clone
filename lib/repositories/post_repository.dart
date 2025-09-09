import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/post_model.dart';
import '../constants/firebase_constants.dart';
import '../utils/firebase_exceptions.dart';

part 'post_repository.g.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 게시물 컬렉션 참조
  CollectionReference<Map<String, dynamic>> get _postsCollection =>
      _firestore.collection(FirebaseConstants.postsCollection);

  // ==================== CREATE ====================

  /// 새 게시물 생성
  /// [post] 생성할 게시물 모델
  /// 반환값: 생성된 게시물의 ID
  Future<String> createPost(PostModel post) async {
    try {
      final DocumentReference docRef = await _postsCollection.add(post.toFirestoreForCreate());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물 작성에 실패했습니다: ${e.toString()}';
    }
  }

  /// 익명 게시물 생성
  /// [text] 게시물 텍스트
  /// [imageUrls] 첨부 이미지 URL 리스트
  /// 반환값: 생성된 게시물의 ID
  Future<String> createAnonymousPost({
    required String text,
    List<String>? imageUrls,
  }) async {
    final post = PostModel.anonymous(
      text: text,
      imageUrls: imageUrls,
    );
    return await createPost(post);
  }

  // ==================== READ ====================

  /// 모든 게시물을 시간순으로 가져오기 (실시간 스트림)
  /// [limit] 가져올 게시물 수 (기본값: 20)
  /// 반환값: 게시물 리스트 스트림
  Stream<List<PostModel>> getPostsStream({int limit = 20}) {
    try {
      return _postsCollection
          .orderBy(FirebaseConstants.postCreatedAtField, descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
      });
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물을 불러오는데 실패했습니다: ${e.toString()}';
    }
  }

  /// 모든 게시물을 시간순으로 가져오기 (한번만)
  /// [limit] 가져올 게시물 수 (기본값: 20)
  /// 반환값: 게시물 리스트
  Future<List<PostModel>> getPosts({int limit = 20}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _postsCollection
          .orderBy(FirebaseConstants.postCreatedAtField, descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물을 불러오는데 실패했습니다: ${e.toString()}';
    }
  }

  /// 특정 게시물 가져오기
  /// [postId] 게시물 ID
  /// 반환값: 게시물 모델 (없으면 null)
  Future<PostModel?> getPost(String postId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _postsCollection.doc(postId).get();
      
      if (!doc.exists) return null;
      
      return PostModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물을 불러오는데 실패했습니다: ${e.toString()}';
    }
  }

  /// 특정 사용자의 게시물 가져오기
  /// [username] 사용자명
  /// [limit] 가져올 게시물 수 (기본값: 20)
  /// 반환값: 게시물 리스트
  Future<List<PostModel>> getPostsByUser({
    required String username,
    int limit = 20,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _postsCollection
          .where(FirebaseConstants.postUsernameField, isEqualTo: username)
          .orderBy(FirebaseConstants.postCreatedAtField, descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '사용자 게시물을 불러오는데 실패했습니다: ${e.toString()}';
    }
  }

  /// 페이지네이션을 지원하는 게시물 가져오기
  /// [limit] 가져올 게시물 수
  /// [lastDocument] 마지막 문서 (다음 페이지 가져올 때 사용)
  /// 반환값: 게시물 리스트와 마지막 문서
  Future<({List<PostModel> posts, DocumentSnapshot? lastDocument})> getPostsWithPagination({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _postsCollection
          .orderBy(FirebaseConstants.postCreatedAtField, descending: true)
          .limit(limit);
      
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      final List<PostModel> posts = snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
      final DocumentSnapshot? newLastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      
      return (posts: posts, lastDocument: newLastDocument);
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물을 불러오는데 실패했습니다: ${e.toString()}';
    }
  }

  // ==================== UPDATE ====================

  /// 게시물 업데이트
  /// [postId] 게시물 ID
  /// [updates] 업데이트할 데이터
  Future<void> updatePost(String postId, Map<String, dynamic> updates) async {
    try {
      await _postsCollection.doc(postId).update({
        ...updates,
        FirebaseConstants.postUpdatedAtField: FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물 수정에 실패했습니다: ${e.toString()}';
    }
  }

  /// 게시물 좋아요 수 증가
  /// [postId] 게시물 ID
  /// [avatarUrl] 좋아요를 누른 사용자의 아바타 URL
  Future<void> likePost(String postId, {String? avatarUrl}) async {
    try {
      final Map<String, dynamic> updates = {
        FirebaseConstants.postLikesField: FieldValue.increment(1),
      };
      
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        updates[FirebaseConstants.postLikedByAvatarsField] = FieldValue.arrayUnion([avatarUrl]);
      }
      
      await updatePost(postId, updates);
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '좋아요 처리에 실패했습니다: ${e.toString()}';
    }
  }

  /// 게시물 좋아요 취소
  /// [postId] 게시물 ID
  /// [avatarUrl] 좋아요를 취소한 사용자의 아바타 URL
  Future<void> unlikePost(String postId, {String? avatarUrl}) async {
    try {
      final Map<String, dynamic> updates = {
        FirebaseConstants.postLikesField: FieldValue.increment(-1),
      };
      
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        updates[FirebaseConstants.postLikedByAvatarsField] = FieldValue.arrayRemove([avatarUrl]);
      }
      
      await updatePost(postId, updates);
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '좋아요 취소 처리에 실패했습니다: ${e.toString()}';
    }
  }

  /// 게시물 댓글 수 증가
  /// [postId] 게시물 ID
  Future<void> incrementReplies(String postId) async {
    try {
      await updatePost(postId, {
        FirebaseConstants.postRepliesField: FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '댓글 수 업데이트에 실패했습니다: ${e.toString()}';
    }
  }

  /// 게시물 댓글 수 감소
  /// [postId] 게시물 ID
  Future<void> decrementReplies(String postId) async {
    try {
      await updatePost(postId, {
        FirebaseConstants.postRepliesField: FieldValue.increment(-1),
      });
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '댓글 수 업데이트에 실패했습니다: ${e.toString()}';
    }
  }

  // ==================== DELETE ====================

  /// 게시물 삭제
  /// [postId] 삭제할 게시물 ID
  Future<void> deletePost(String postId) async {
    try {
      await _postsCollection.doc(postId).delete();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물 삭제에 실패했습니다: ${e.toString()}';
    }
  }

  /// 여러 게시물 삭제 (배치 처리)
  /// [postIds] 삭제할 게시물 ID 리스트
  Future<void> deletePosts(List<String> postIds) async {
    if (postIds.isEmpty) return;
    
    try {
      final WriteBatch batch = _firestore.batch();
      
      for (String postId in postIds) {
        batch.delete(_postsCollection.doc(postId));
      }
      
      await batch.commit();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물 삭제에 실패했습니다: ${e.toString()}';
    }
  }

  // ==================== SEARCH ====================

  /// 텍스트로 게시물 검색
  /// [searchTerm] 검색어
  /// [limit] 결과 개수 제한
  /// 반환값: 검색된 게시물 리스트
  Future<List<PostModel>> searchPosts({
    required String searchTerm,
    int limit = 20,
  }) async {
    try {
      // Firestore는 full-text search를 직접 지원하지 않으므로
      // 간단한 텍스트 매칭을 사용합니다.
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _postsCollection
          .where(FirebaseConstants.postTextField, isGreaterThanOrEqualTo: searchTerm)
          .where(FirebaseConstants.postTextField, isLessThan: '${searchTerm}z')
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물 검색에 실패했습니다: ${e.toString()}';
    }
  }

  // ==================== STATISTICS ====================

  /// 총 게시물 수 가져오기
  Future<int> getTotalPostsCount() async {
    try {
      final AggregateQuerySnapshot snapshot = await _postsCollection.count().get();
      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '게시물 수를 가져오는데 실패했습니다: ${e.toString()}';
    }
  }

  /// 특정 사용자의 게시물 수 가져오기
  Future<int> getUserPostsCount(String username) async {
    try {
      final AggregateQuerySnapshot snapshot = await _postsCollection
          .where(FirebaseConstants.postUsernameField, isEqualTo: username)
          .count()
          .get();
      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler.handleFirestoreException(e);
    } catch (e) {
      throw '사용자 게시물 수를 가져오는데 실패했습니다: ${e.toString()}';
    }
  }
}

// Riverpod Providers
@Riverpod(keepAlive: true)
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository();
}

// 게시물 스트림 제공
@riverpod
Stream<List<PostModel>> postsStream(PostsStreamRef ref, {int limit = 20}) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostsStream(limit: limit);
}

// 특정 게시물 제공
@riverpod
Future<PostModel?> post(PostRef ref, String postId) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPost(postId);
}

// 사용자별 게시물 제공
@riverpod
Future<List<PostModel>> userPosts(UserPostsRef ref, String username, {int limit = 20}) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostsByUser(username: username, limit: limit);
}