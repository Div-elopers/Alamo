// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_center_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$helpCenterRepositoryHash() =>
    r'05bcfaf578fc30f8da2ef7134d41a1629e7a1832';

/// See also [helpCenterRepository].
@ProviderFor(helpCenterRepository)
final helpCenterRepositoryProvider = Provider<HelpCenterRepository>.internal(
  helpCenterRepository,
  name: r'helpCenterRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$helpCenterRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HelpCenterRepositoryRef = ProviderRef<HelpCenterRepository>;
String _$helpCentersListStreamHash() =>
    r'04308ca2af226090e87303a2d40d1b5463127b29';

/// See also [helpCentersListStream].
@ProviderFor(helpCentersListStream)
final helpCentersListStreamProvider =
    AutoDisposeStreamProvider<List<HelpCenter>>.internal(
  helpCentersListStream,
  name: r'helpCentersListStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$helpCentersListStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HelpCentersListStreamRef
    = AutoDisposeStreamProviderRef<List<HelpCenter>>;
String _$helpCentersListFutureHash() =>
    r'426355ca7482be5def8ca0c6de63adc79e72c4e0';

/// See also [helpCentersListFuture].
@ProviderFor(helpCentersListFuture)
final helpCentersListFutureProvider =
    AutoDisposeFutureProvider<List<HelpCenter>>.internal(
  helpCentersListFuture,
  name: r'helpCentersListFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$helpCentersListFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HelpCentersListFutureRef
    = AutoDisposeFutureProviderRef<List<HelpCenter>>;
String _$helpCenterStreamHash() => r'd07b9c005966af5066c8dce6b7daafd2b788f448';

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

/// See also [helpCenterStream].
@ProviderFor(helpCenterStream)
const helpCenterStreamProvider = HelpCenterStreamFamily();

/// See also [helpCenterStream].
class HelpCenterStreamFamily extends Family<AsyncValue<HelpCenter?>> {
  /// See also [helpCenterStream].
  const HelpCenterStreamFamily();

  /// See also [helpCenterStream].
  HelpCenterStreamProvider call(
    String uid,
  ) {
    return HelpCenterStreamProvider(
      uid,
    );
  }

  @override
  HelpCenterStreamProvider getProviderOverride(
    covariant HelpCenterStreamProvider provider,
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
  String? get name => r'helpCenterStreamProvider';
}

/// See also [helpCenterStream].
class HelpCenterStreamProvider extends AutoDisposeStreamProvider<HelpCenter?> {
  /// See also [helpCenterStream].
  HelpCenterStreamProvider(
    String uid,
  ) : this._internal(
          (ref) => helpCenterStream(
            ref as HelpCenterStreamRef,
            uid,
          ),
          from: helpCenterStreamProvider,
          name: r'helpCenterStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$helpCenterStreamHash,
          dependencies: HelpCenterStreamFamily._dependencies,
          allTransitiveDependencies:
              HelpCenterStreamFamily._allTransitiveDependencies,
          uid: uid,
        );

  HelpCenterStreamProvider._internal(
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
    Stream<HelpCenter?> Function(HelpCenterStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HelpCenterStreamProvider._internal(
        (ref) => create(ref as HelpCenterStreamRef),
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
  AutoDisposeStreamProviderElement<HelpCenter?> createElement() {
    return _HelpCenterStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HelpCenterStreamProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HelpCenterStreamRef on AutoDisposeStreamProviderRef<HelpCenter?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _HelpCenterStreamProviderElement
    extends AutoDisposeStreamProviderElement<HelpCenter?>
    with HelpCenterStreamRef {
  _HelpCenterStreamProviderElement(super.provider);

  @override
  String get uid => (origin as HelpCenterStreamProvider).uid;
}

String _$helpCenterFutureHash() => r'3f80f986dad8cffee019b255000ddc8fb68a54e3';

/// See also [helpCenterFuture].
@ProviderFor(helpCenterFuture)
const helpCenterFutureProvider = HelpCenterFutureFamily();

/// See also [helpCenterFuture].
class HelpCenterFutureFamily extends Family<AsyncValue<HelpCenter?>> {
  /// See also [helpCenterFuture].
  const HelpCenterFutureFamily();

  /// See also [helpCenterFuture].
  HelpCenterFutureProvider call(
    String uid,
  ) {
    return HelpCenterFutureProvider(
      uid,
    );
  }

  @override
  HelpCenterFutureProvider getProviderOverride(
    covariant HelpCenterFutureProvider provider,
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
  String? get name => r'helpCenterFutureProvider';
}

/// See also [helpCenterFuture].
class HelpCenterFutureProvider extends AutoDisposeFutureProvider<HelpCenter?> {
  /// See also [helpCenterFuture].
  HelpCenterFutureProvider(
    String uid,
  ) : this._internal(
          (ref) => helpCenterFuture(
            ref as HelpCenterFutureRef,
            uid,
          ),
          from: helpCenterFutureProvider,
          name: r'helpCenterFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$helpCenterFutureHash,
          dependencies: HelpCenterFutureFamily._dependencies,
          allTransitiveDependencies:
              HelpCenterFutureFamily._allTransitiveDependencies,
          uid: uid,
        );

  HelpCenterFutureProvider._internal(
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
    FutureOr<HelpCenter?> Function(HelpCenterFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HelpCenterFutureProvider._internal(
        (ref) => create(ref as HelpCenterFutureRef),
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
  AutoDisposeFutureProviderElement<HelpCenter?> createElement() {
    return _HelpCenterFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HelpCenterFutureProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HelpCenterFutureRef on AutoDisposeFutureProviderRef<HelpCenter?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _HelpCenterFutureProviderElement
    extends AutoDisposeFutureProviderElement<HelpCenter?>
    with HelpCenterFutureRef {
  _HelpCenterFutureProviderElement(super.provider);

  @override
  String get uid => (origin as HelpCenterFutureProvider).uid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
