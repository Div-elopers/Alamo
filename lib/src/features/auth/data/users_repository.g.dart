// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'fe2c0bda2af6dcd956746cc05a129e4b2ebd72c7';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UsersRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = ProviderRef<UsersRepository>;
String _$usersListStreamHash() => r'f9b28789a013ccd0c1a69d9eefaa4aa94e2719a7';

/// See also [usersListStream].
@ProviderFor(usersListStream)
final usersListStreamProvider =
    AutoDisposeStreamProvider<List<AppUser>>.internal(
  usersListStream,
  name: r'usersListStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersListStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UsersListStreamRef = AutoDisposeStreamProviderRef<List<AppUser>>;
String _$usersListFutureHash() => r'983e35783e750efbb2c14fa49d80d27b280e43f9';

/// See also [usersListFuture].
@ProviderFor(usersListFuture)
final usersListFutureProvider =
    AutoDisposeFutureProvider<List<AppUser>>.internal(
  usersListFuture,
  name: r'usersListFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersListFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UsersListFutureRef = AutoDisposeFutureProviderRef<List<AppUser>>;
String _$userStreamHash() => r'51ad1f9e95ba402637ce8ef6a77b56276ceac54f';

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

/// See also [userStream].
@ProviderFor(userStream)
const userStreamProvider = UserStreamFamily();

/// See also [userStream].
class UserStreamFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [userStream].
  const UserStreamFamily();

  /// See also [userStream].
  UserStreamProvider call(
    String uid,
  ) {
    return UserStreamProvider(
      uid,
    );
  }

  @override
  UserStreamProvider getProviderOverride(
    covariant UserStreamProvider provider,
  ) {
    return call(
      provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userStreamProvider';
}

/// See also [userStream].
class UserStreamProvider extends AutoDisposeStreamProvider<AppUser?> {
  /// See also [userStream].
  UserStreamProvider(
    String uid,
  ) : this._internal(
          (ref) => userStream(
            ref as UserStreamRef,
            uid,
          ),
          from: userStreamProvider,
          name: r'userStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userStreamHash,
          dependencies: UserStreamFamily._dependencies,
          allTransitiveDependencies:
              UserStreamFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<AppUser?> Function(UserStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserStreamProvider._internal(
        (ref) => create(ref as UserStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AppUser?> createElement() {
    return _UserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserStreamProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserStreamRef on AutoDisposeStreamProviderRef<AppUser?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserStreamProviderElement
    extends AutoDisposeStreamProviderElement<AppUser?> with UserStreamRef {
  _UserStreamProviderElement(super.provider);

  @override
  String get uid => (origin as UserStreamProvider).uid;
}

String _$userFutureHash() => r'a2fd36e53015270faaf64840cbe92ac373e8d10c';

/// See also [userFuture].
@ProviderFor(userFuture)
const userFutureProvider = UserFutureFamily();

/// See also [userFuture].
class UserFutureFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [userFuture].
  const UserFutureFamily();

  /// See also [userFuture].
  UserFutureProvider call(
    String uid,
  ) {
    return UserFutureProvider(
      uid,
    );
  }

  @override
  UserFutureProvider getProviderOverride(
    covariant UserFutureProvider provider,
  ) {
    return call(
      provider.uid,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userFutureProvider';
}

/// See also [userFuture].
class UserFutureProvider extends AutoDisposeFutureProvider<AppUser?> {
  /// See also [userFuture].
  UserFutureProvider(
    String uid,
  ) : this._internal(
          (ref) => userFuture(
            ref as UserFutureRef,
            uid,
          ),
          from: userFutureProvider,
          name: r'userFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userFutureHash,
          dependencies: UserFutureFamily._dependencies,
          allTransitiveDependencies:
              UserFutureFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(UserFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserFutureProvider._internal(
        (ref) => create(ref as UserFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser?> createElement() {
    return _UserFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserFutureProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserFutureRef on AutoDisposeFutureProviderRef<AppUser?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserFutureProviderElement
    extends AutoDisposeFutureProviderElement<AppUser?> with UserFutureRef {
  _UserFutureProviderElement(super.provider);

  @override
  String get uid => (origin as UserFutureProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
