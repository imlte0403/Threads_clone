// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postsStreamHash() => r'477f1f7fde3a5975e3ae0dcb2dd15f28a68ba902';

/// 실시간 게시물 스트림을 제공하는 Provider
///
/// Copied from [postsStream].
@ProviderFor(postsStream)
final postsStreamProvider = AutoDisposeStreamProvider<List<PostModel>>.internal(
  postsStream,
  name: r'postsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PostsStreamRef = AutoDisposeStreamProviderRef<List<PostModel>>;
String _$singlePostHash() => r'3b1c1452f353f4589fc40f3c41146201fa572b1a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 특정 게시물을 제공하는 Provider
///
/// Copied from [singlePost].
@ProviderFor(singlePost)
const singlePostProvider = SinglePostFamily();

/// 특정 게시물을 제공하는 Provider
///
/// Copied from [singlePost].
class SinglePostFamily extends Family<AsyncValue<PostModel?>> {
  /// 특정 게시물을 제공하는 Provider
  ///
  /// Copied from [singlePost].
  const SinglePostFamily();

  /// 특정 게시물을 제공하는 Provider
  ///
  /// Copied from [singlePost].
  SinglePostProvider call(String postId) {
    return SinglePostProvider(postId);
  }

  @override
  SinglePostProvider getProviderOverride(
    covariant SinglePostProvider provider,
  ) {
    return call(provider.postId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'singlePostProvider';
}

/// 특정 게시물을 제공하는 Provider
///
/// Copied from [singlePost].
class SinglePostProvider extends AutoDisposeFutureProvider<PostModel?> {
  /// 특정 게시물을 제공하는 Provider
  ///
  /// Copied from [singlePost].
  SinglePostProvider(String postId)
    : this._internal(
        (ref) => singlePost(ref as SinglePostRef, postId),
        from: singlePostProvider,
        name: r'singlePostProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$singlePostHash,
        dependencies: SinglePostFamily._dependencies,
        allTransitiveDependencies: SinglePostFamily._allTransitiveDependencies,
        postId: postId,
      );

  SinglePostProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<PostModel?> Function(SinglePostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SinglePostProvider._internal(
        (ref) => create(ref as SinglePostRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PostModel?> createElement() {
    return _SinglePostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SinglePostProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SinglePostRef on AutoDisposeFutureProviderRef<PostModel?> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _SinglePostProviderElement
    extends AutoDisposeFutureProviderElement<PostModel?>
    with SinglePostRef {
  _SinglePostProviderElement(super.provider);

  @override
  String get postId => (origin as SinglePostProvider).postId;
}

String _$totalPostsCountHash() => r'ef33ac7b63d57fa5efcbea653dd890375a6f6a30';

/// 통계 정보를 제공하는 Provider
///
/// Copied from [totalPostsCount].
@ProviderFor(totalPostsCount)
final totalPostsCountProvider = AutoDisposeFutureProvider<int>.internal(
  totalPostsCount,
  name: r'totalPostsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalPostsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalPostsCountRef = AutoDisposeFutureProviderRef<int>;
String _$homeViewModelHash() => r'9956ecdc034895e0950c725450f015ce9753b58b';

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider =
    AutoDisposeNotifierProvider<HomeViewModel, HomeState>.internal(
      HomeViewModel.new,
      name: r'homeViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$homeViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HomeViewModel = AutoDisposeNotifier<HomeState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
