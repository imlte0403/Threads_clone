import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:thread_clone/models/post_model.dart';
import 'package:thread_clone/repositories/post_repository.dart';

part 'search_viewmodel.g.dart';

@riverpod
class SearchViewModel extends _$SearchViewModel {
  late final PostRepository _repository;

  @override
  FutureOr<List<PostModel>> build() {
    _repository = ref.read(postRepositoryProvider);
    // 초기 상태는 빈 리스트
    return [];
  }

  Future<void> searchPosts(String query) async {
    state = const AsyncValue.loading();
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = await AsyncValue.guard(() async {
      return _repository.searchPosts(searchTerm: query);
    });
  }
}
