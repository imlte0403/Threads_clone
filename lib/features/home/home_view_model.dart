import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/post_model.dart';
import '../../repositories/post_repository.dart';
import '../../utils/firebase_exceptions.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    // 초기 상태 반환 후 게시물 로드 시작
    Future.microtask(() => _loadPosts());
    return const HomeState();
  }

  // ==================== Data Loading ====================

  /// 초기 게시물 로드
  Future<void> _loadPosts() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(postRepositoryProvider);
      final result = await repository.getPostsWithPagination(limit: state.pageSize);
      
      state = state.copyWith(
        posts: result.posts,
        lastDocument: result.lastDocument,
        isLoading: false,
        hasReachedEnd: result.posts.length < state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: FirebaseExceptionHandler.handleGenericException(e),
      );
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    if (state.isRefreshing) return;

    state = state.copyWith(
      isRefreshing: true,
      errorMessage: null,
    );

    try {
      final repository = ref.read(postRepositoryProvider);
      final result = await repository.getPostsWithPagination(limit: state.pageSize);
      
      state = state.copyWith(
        posts: result.posts,
        lastDocument: result.lastDocument,
        isRefreshing: false,
        hasReachedEnd: result.posts.length < state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: FirebaseExceptionHandler.handleGenericException(e),
      );
    }
  }

  /// 더 많은 게시물 로드 (무한 스크롤)
  Future<void> loadMore() async {
    if (state.isLoadingMore || state.hasReachedEnd || state.lastDocument == null) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final repository = ref.read(postRepositoryProvider);
      final result = await repository.getPostsWithPagination(
        limit: state.pageSize,
        lastDocument: state.lastDocument,
      );
      
      final updatedPosts = [...state.posts, ...result.posts];
      
      state = state.copyWith(
        posts: updatedPosts,
        lastDocument: result.lastDocument,
        isLoadingMore: false,
        hasReachedEnd: result.posts.length < state.pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: FirebaseExceptionHandler.handleGenericException(e),
      );
    }
  }

  // ==================== Post Interactions ====================

  /// 게시물 좋아요
  Future<void> likePost(String postId, {String? avatarUrl}) async {
    try {
      final repository = ref.read(postRepositoryProvider);
      await repository.likePost(postId, avatarUrl: avatarUrl);
      
      // 로컬 상태 업데이트
      _updatePostLocally(postId, (post) => post.copyWith(
        likes: post.likes + 1,
        likedByAvatars: avatarUrl != null && avatarUrl.isNotEmpty
            ? [...post.likedByAvatars, avatarUrl]
            : post.likedByAvatars,
      ));
    } catch (e) {
      state = state.copyWith(
        errorMessage: '좋아요 처리 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  /// 게시물 좋아요 취소
  Future<void> unlikePost(String postId, {String? avatarUrl}) async {
    try {
      final repository = ref.read(postRepositoryProvider);
      await repository.unlikePost(postId, avatarUrl: avatarUrl);
      
      // 로컬 상태 업데이트
      _updatePostLocally(postId, (post) => post.copyWith(
        likes: (post.likes - 1).clamp(0, double.infinity).toInt(),
        likedByAvatars: avatarUrl != null
            ? post.likedByAvatars.where((url) => url != avatarUrl).toList()
            : post.likedByAvatars,
      ));
    } catch (e) {
      state = state.copyWith(
        errorMessage: '좋아요 취소 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  /// 게시물 삭제
  Future<void> deletePost(String postId) async {
    try {
      final repository = ref.read(postRepositoryProvider);
      await repository.deletePost(postId);
      
      // 로컬 상태에서 제거
      final updatedPosts = state.posts.where((post) => post.id != postId).toList();
      state = state.copyWith(posts: updatedPosts);
      
    } catch (e) {
      state = state.copyWith(
        errorMessage: '게시물 삭제 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  // ==================== Helper Methods ====================

  /// 로컬 게시물 업데이트
  void _updatePostLocally(String postId, PostModel Function(PostModel) updater) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return updater(post);
      }
      return post;
    }).toList();
    
    state = state.copyWith(posts: updatedPosts);
  }

  /// 에러 메시지 클리어
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 특정 게시물 찾기
  PostModel? findPost(String postId) {
    try {
      return state.posts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  // ==================== Search ====================

  /// 게시물 검색
  Future<void> searchPosts(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      await refresh();
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(postRepositoryProvider);
      final searchResults = await repository.searchPosts(
        searchTerm: searchTerm.trim(),
        limit: state.pageSize,
      );
      
      state = state.copyWith(
        posts: searchResults,
        isLoading: false,
        hasReachedEnd: true, // 검색 결과는 페이지네이션 없음
        lastDocument: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: FirebaseExceptionHandler.handleGenericException(e),
      );
    }
  }
}

// ==================== Home State ====================

class HomeState {
  final List<PostModel> posts;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String? errorMessage;
  final DocumentSnapshot? lastDocument;
  final int pageSize;

  const HomeState({
    this.posts = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.errorMessage,
    this.lastDocument,
    this.pageSize = 20,
  });

  /// 상태 복사
  HomeState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    String? errorMessage,
    DocumentSnapshot? lastDocument,
    int? pageSize,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      errorMessage: errorMessage ?? this.errorMessage,
      lastDocument: lastDocument ?? this.lastDocument,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  /// 빈 상태인지 확인
  bool get isEmpty => posts.isEmpty && !isLoading;

  /// 로딩 중인지 확인
  bool get isBusy => isLoading || isRefreshing || isLoadingMore;

  /// 에러가 있는지 확인
  bool get hasError => errorMessage != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.posts.length == posts.length &&
        other.isLoading == isLoading &&
        other.isRefreshing == isRefreshing &&
        other.isLoadingMore == isLoadingMore &&
        other.hasReachedEnd == hasReachedEnd &&
        other.errorMessage == errorMessage &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode {
    return posts.length.hashCode ^
        isLoading.hashCode ^
        isRefreshing.hashCode ^
        isLoadingMore.hashCode ^
        hasReachedEnd.hashCode ^
        (errorMessage?.hashCode ?? 0) ^
        pageSize.hashCode;
  }

  @override
  String toString() {
    return 'HomeState('
        'postsCount: ${posts.length}, '
        'isLoading: $isLoading, '
        'isRefreshing: $isRefreshing, '
        'isLoadingMore: $isLoadingMore, '
        'hasReachedEnd: $hasReachedEnd, '
        'hasError: $hasError'
        ')';
  }
}

// ==================== Additional Providers ====================

/// 실시간 게시물 스트림을 제공하는 Provider
@riverpod
Stream<List<PostModel>> postsStream(Ref ref) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostsStream(limit: 20);
}

/// 특정 게시물을 제공하는 Provider
@riverpod
Future<PostModel?> singlePost(Ref ref, String postId) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPost(postId);
}

/// 통계 정보를 제공하는 Provider
@riverpod
Future<int> totalPostsCount(Ref ref) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getTotalPostsCount();
}