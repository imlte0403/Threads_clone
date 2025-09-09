// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$usersViewModelHash() => r'1b33dc1633512dc60c4ff8e08fc967411913e8ee';

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

abstract class _$UsersViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<String>> {
  late final String keyword;

  FutureOr<List<String>> build(String keyword);
}

/// See also [UsersViewModel].
@ProviderFor(UsersViewModel)
const usersViewModelProvider = UsersViewModelFamily();

/// See also [UsersViewModel].
class UsersViewModelFamily extends Family<AsyncValue<List<String>>> {
  /// See also [UsersViewModel].
  const UsersViewModelFamily();

  /// See also [UsersViewModel].
  UsersViewModelProvider call(String keyword) {
    return UsersViewModelProvider(keyword);
  }

  @override
  UsersViewModelProvider getProviderOverride(
    covariant UsersViewModelProvider provider,
  ) {
    return call(provider.keyword);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'usersViewModelProvider';
}

/// See also [UsersViewModel].
class UsersViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UsersViewModel, List<String>> {
  /// See also [UsersViewModel].
  UsersViewModelProvider(String keyword)
    : this._internal(
        () => UsersViewModel()..keyword = keyword,
        from: usersViewModelProvider,
        name: r'usersViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$usersViewModelHash,
        dependencies: UsersViewModelFamily._dependencies,
        allTransitiveDependencies:
            UsersViewModelFamily._allTransitiveDependencies,
        keyword: keyword,
      );

  UsersViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
  }) : super.internal();

  final String keyword;

  @override
  FutureOr<List<String>> runNotifierBuild(covariant UsersViewModel notifier) {
    return notifier.build(keyword);
  }

  @override
  Override overrideWith(UsersViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: UsersViewModelProvider._internal(
        () => create()..keyword = keyword,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UsersViewModel, List<String>>
  createElement() {
    return _UsersViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UsersViewModelProvider && other.keyword == keyword;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UsersViewModelRef on AutoDisposeAsyncNotifierProviderRef<List<String>> {
  /// The parameter `keyword` of this provider.
  String get keyword;
}

class _UsersViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<UsersViewModel, List<String>>
    with UsersViewModelRef {
  _UsersViewModelProviderElement(super.provider);

  @override
  String get keyword => (origin as UsersViewModelProvider).keyword;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
