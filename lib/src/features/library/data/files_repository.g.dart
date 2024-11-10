// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filesRepositoryHash() => r'5bd0a30e10b054ea6ea66ef7b621cd3dc09c3e0b';

/// See also [filesRepository].
@ProviderFor(filesRepository)
final filesRepositoryProvider = Provider<FilesRepository>.internal(
  filesRepository,
  name: r'filesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilesRepositoryRef = ProviderRef<FilesRepository>;
String _$filesListStreamHash() => r'0211a3016152c265ace27f4f5e5494c8301bb150';

/// See also [filesListStream].
@ProviderFor(filesListStream)
final filesListStreamProvider =
    AutoDisposeStreamProvider<List<AppFile>>.internal(
  filesListStream,
  name: r'filesListStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filesListStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilesListStreamRef = AutoDisposeStreamProviderRef<List<AppFile>>;
String _$filesListFutureHash() => r'9d03f8093a17c48e3da1275d52108905c15b6f7e';

/// See also [filesListFuture].
@ProviderFor(filesListFuture)
final filesListFutureProvider =
    AutoDisposeFutureProvider<List<AppFile>>.internal(
  filesListFuture,
  name: r'filesListFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filesListFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilesListFutureRef = AutoDisposeFutureProviderRef<List<AppFile>>;
String _$fileStreamHash() => r'5573bd71f281f85ec31cb71cf129dc7e11b25777';

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

/// See also [fileStream].
@ProviderFor(fileStream)
const fileStreamProvider = FileStreamFamily();

/// See also [fileStream].
class FileStreamFamily extends Family<AsyncValue<AppFile?>> {
  /// See also [fileStream].
  const FileStreamFamily();

  /// See also [fileStream].
  FileStreamProvider call(
    String id,
  ) {
    return FileStreamProvider(
      id,
    );
  }

  @override
  FileStreamProvider getProviderOverride(
    covariant FileStreamProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'fileStreamProvider';
}

/// See also [fileStream].
class FileStreamProvider extends AutoDisposeStreamProvider<AppFile?> {
  /// See also [fileStream].
  FileStreamProvider(
    String id,
  ) : this._internal(
          (ref) => fileStream(
            ref as FileStreamRef,
            id,
          ),
          from: fileStreamProvider,
          name: r'fileStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fileStreamHash,
          dependencies: FileStreamFamily._dependencies,
          allTransitiveDependencies:
              FileStreamFamily._allTransitiveDependencies,
          id: id,
        );

  FileStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<AppFile?> Function(FileStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FileStreamProvider._internal(
        (ref) => create(ref as FileStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AppFile?> createElement() {
    return _FileStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FileStreamProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FileStreamRef on AutoDisposeStreamProviderRef<AppFile?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _FileStreamProviderElement
    extends AutoDisposeStreamProviderElement<AppFile?> with FileStreamRef {
  _FileStreamProviderElement(super.provider);

  @override
  String get id => (origin as FileStreamProvider).id;
}

String _$fileFutureHash() => r'1a33d5db448590c22b79f8c7431006b06fd008da';

/// See also [fileFuture].
@ProviderFor(fileFuture)
const fileFutureProvider = FileFutureFamily();

/// See also [fileFuture].
class FileFutureFamily extends Family<AsyncValue<AppFile?>> {
  /// See also [fileFuture].
  const FileFutureFamily();

  /// See also [fileFuture].
  FileFutureProvider call(
    String id,
  ) {
    return FileFutureProvider(
      id,
    );
  }

  @override
  FileFutureProvider getProviderOverride(
    covariant FileFutureProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'fileFutureProvider';
}

/// See also [fileFuture].
class FileFutureProvider extends AutoDisposeFutureProvider<AppFile?> {
  /// See also [fileFuture].
  FileFutureProvider(
    String id,
  ) : this._internal(
          (ref) => fileFuture(
            ref as FileFutureRef,
            id,
          ),
          from: fileFutureProvider,
          name: r'fileFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fileFutureHash,
          dependencies: FileFutureFamily._dependencies,
          allTransitiveDependencies:
              FileFutureFamily._allTransitiveDependencies,
          id: id,
        );

  FileFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<AppFile?> Function(FileFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FileFutureProvider._internal(
        (ref) => create(ref as FileFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppFile?> createElement() {
    return _FileFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FileFutureProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FileFutureRef on AutoDisposeFutureProviderRef<AppFile?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _FileFutureProviderElement
    extends AutoDisposeFutureProviderElement<AppFile?> with FileFutureRef {
  _FileFutureProviderElement(super.provider);

  @override
  String get id => (origin as FileFutureProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
