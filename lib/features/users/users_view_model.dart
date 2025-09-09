import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_view_model.g.dart';

@riverpod
class UsersViewModel extends _$UsersViewModel {
  @override
  FutureOr<List<String>> build(String keyword) async {
    // TODO: 실제 사용자 검색 로직 구현
    // Firestore에서 사용자를 검색하는 로직을 여기에 구현
    await Future.delayed(const Duration(milliseconds: 500)); // 시뮬레이션
    
    if (keyword.isEmpty) {
      return [];
    }
    
    // 임시 데이터 반환 (실제 구현 시 Firestore 쿼리로 교체)
    return [
      'user1@example.com',
      'user2@example.com',
      'user3@example.com',
    ].where((user) => user.toLowerCase().contains(keyword.toLowerCase())).toList();
  }

  Future<void> searchUsers(String keyword) async {
    // 키워드가 변경되면 자동으로 build가 호출되어 새로운 검색 결과를 가져옵니다
    ref.invalidateSelf();
  }
}