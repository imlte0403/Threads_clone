// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postRepositoryHash() => r'55bcb6ecb92e2b8963301b317920927ebfd98d13';

/// See also [postRepository].
@ProviderFor(postRepository)
final postRepositoryProvider = Provider<PostRepository>.internal(
  postRepository,
  name: r'postRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PostRepositoryRef = ProviderRef<PostRepository>;
String _$postsStreamHash() => r'7cbd0450b331a902cc146bbb0347181adb8d2832';

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

/// See also [postsStream].
@ProviderFor(postsStream)
const postsStreamProvider = PostsStreamFamily();

/// See also [postsStream].
class PostsStreamFamily extends Family<AsyncValue<List<PostModel>>> {
  /// See also [postsStream].
  const PostsStreamFamily();

  /// See also [postsStream].
  PostsStreamProvider call({int limit = 20}) {
    return PostsStreamProvider(limit: limit);
  }

  @override
  PostsStreamProvider getProviderOverride(
    covariant PostsStreamProvider provider,
  ) {
    return call(limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postsStreamProvider';
}

/// See also [postsStream].
class PostsStreamProvider extends AutoDisposeStreamProvider<List<PostModel>> {
  /// See also [postsStream].
  PostsStreamProvider({int limit = 20})
    : this._internal(
        (ref) => postsStream(ref as PostsStreamRef, limit: limit),
        from: postsStreamProvider,
        name: r'postsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$postsStreamHash,
        dependencies: PostsStreamFamily._dependencies,
        allTransitiveDependencies: PostsStreamFamily._allTransitiveDependencies,
        limit: limit,
      );

  PostsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    Stream<List<PostModel>> Function(PostsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostsStreamProvider._internal(
        (ref) => create(ref as PostsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PostModel>> createElement() {
    return _PostsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostsStreamProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostsStreamRef on AutoDisposeStreamProviderRef<List<PostModel>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _PostsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<PostModel>>
    with PostsStreamRef {
  _PostsStreamProviderElement(super.provider);

  @override
  int get limit => (origin as PostsStreamProvider).limit;
}

String _$postHash() => r'6d6f998915982533ce9675631387516e39ca8968';

/// See also [post].
@ProviderFor(post)
const postProvider = PostFamily();

/// See also [post].
class PostFamily extends Family<AsyncValue<PostModel?>> {
  /// See also [post].
  const PostFamily();

  /// See also [post].
  PostProvider call(String postId) {
    return PostProvider(postId);
  }

  @override
  PostProvider getProviderOverride(covariant PostProvider provider) {
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
  String? get name => r'postProvider';
}

/// See also [post].
class PostProvider extends AutoDisposeFutureProvider<PostModel?> {
  /// See also [post].
  PostProvider(String postId)
    : this._internal(
        (ref) => post(ref as PostRef, postId),
        from: postProvider,
        name: r'postProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$postHash,
        dependencies: PostFamily._dependencies,
        allTransitiveDependencies: PostFamily._allTransitiveDependencies,
        postId: postId,
      );

  PostProvider._internal(
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
    FutureOr<PostModel?> Function(PostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostProvider._internal(
        (ref) => create(ref as PostRef),
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
    return _PostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostProvider && other.postId == postId;
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
mixin PostRef on AutoDisposeFutureProviderRef<PostModel?> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _PostProviderElement extends AutoDisposeFutureProviderElement<PostModel?>
    with PostRef {
  _PostProviderElement(super.provider);

  @override
  String get postId => (origin as PostProvider).postId;
}

String _$userPostsHash() => r'517c96b6acea9cbc9c514b6aef0f8ed45927f2c4';

/// See also [userPosts].
@ProviderFor(userPosts)
const userPostsProvider = UserPostsFamily();

/// See also [userPosts].
class UserPostsFamily extends Family<AsyncValue<List<PostModel>>> {
  /// See also [userPosts].
  const UserPostsFamily();

  /// See also [userPosts].
  UserPostsProvider call(String username, {int limit = 20}) {
    return UserPostsProvider(username, limit: limit);
  }

  @override
  UserPostsProvider getProviderOverride(covariant UserPostsProvider provider) {
    return call(provider.username, limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userPostsProvider';
}

/// See also [userPosts].
class UserPostsProvider extends AutoDisposeFutureProvider<List<PostModel>> {
  /// See also [userPosts].
  UserPostsProvider(String username, {int limit = 20})
    : this._internal(
        (ref) => userPosts(ref as UserPostsRef, username, limit: limit),
        from: userPostsProvider,
        name: r'userPostsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userPostsHash,
        dependencies: UserPostsFamily._dependencies,
        allTransitiveDependencies: UserPostsFamily._allTransitiveDependencies,
        username: username,
        limit: limit,
      );

  UserPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.username,
    required this.limit,
  }) : super.internal();

  final String username;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<PostModel>> Function(UserPostsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserPostsProvider._internal(
        (ref) => create(ref as UserPostsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        username: username,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PostModel>> createElement() {
    return _UserPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostsProvider &&
        other.username == username &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, username.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserPostsRef on AutoDisposeFutureProviderRef<List<PostModel>> {
  /// The parameter `username` of this provider.
  String get username;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _UserPostsProviderElement
    extends AutoDisposeFutureProviderElement<List<PostModel>>
    with UserPostsRef {
  _UserPostsProviderElement(super.provider);

  @override
  String get username => (origin as UserPostsProvider).username;
  @override
  int get limit => (origin as UserPostsProvider).limit;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
