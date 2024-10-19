// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'0d22e5d8b587219c00b78c2994979e20c82a2d4d';

/// See also [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = Provider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatRepositoryRef = ProviderRef<ChatRepository>;
String _$chatThreadStreamHash() => r'bc99c66b476f0fb1a17f9edd6aca3404e74b53bb';

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

/// See also [chatThreadStream].
@ProviderFor(chatThreadStream)
const chatThreadStreamProvider = ChatThreadStreamFamily();

/// See also [chatThreadStream].
class ChatThreadStreamFamily extends Family<AsyncValue<Thread?>> {
  /// See also [chatThreadStream].
  const ChatThreadStreamFamily();

  /// See also [chatThreadStream].
  ChatThreadStreamProvider call(
    String threadId,
  ) {
    return ChatThreadStreamProvider(
      threadId,
    );
  }

  @override
  ChatThreadStreamProvider getProviderOverride(
    covariant ChatThreadStreamProvider provider,
  ) {
    return call(
      provider.threadId,
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
  String? get name => r'chatThreadStreamProvider';
}

/// See also [chatThreadStream].
class ChatThreadStreamProvider extends AutoDisposeStreamProvider<Thread?> {
  /// See also [chatThreadStream].
  ChatThreadStreamProvider(
    String threadId,
  ) : this._internal(
          (ref) => chatThreadStream(
            ref as ChatThreadStreamRef,
            threadId,
          ),
          from: chatThreadStreamProvider,
          name: r'chatThreadStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatThreadStreamHash,
          dependencies: ChatThreadStreamFamily._dependencies,
          allTransitiveDependencies:
              ChatThreadStreamFamily._allTransitiveDependencies,
          threadId: threadId,
        );

  ChatThreadStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadId,
  }) : super.internal();

  final String threadId;

  @override
  Override overrideWith(
    Stream<Thread?> Function(ChatThreadStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatThreadStreamProvider._internal(
        (ref) => create(ref as ChatThreadStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threadId: threadId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Thread?> createElement() {
    return _ChatThreadStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatThreadStreamProvider && other.threadId == threadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatThreadStreamRef on AutoDisposeStreamProviderRef<Thread?> {
  /// The parameter `threadId` of this provider.
  String get threadId;
}

class _ChatThreadStreamProviderElement
    extends AutoDisposeStreamProviderElement<Thread?> with ChatThreadStreamRef {
  _ChatThreadStreamProviderElement(super.provider);

  @override
  String get threadId => (origin as ChatThreadStreamProvider).threadId;
}

String _$chatThreadFutureHash() => r'8c6807e12a8e01dcf6ee842953a09294861f26df';

/// See also [chatThreadFuture].
@ProviderFor(chatThreadFuture)
const chatThreadFutureProvider = ChatThreadFutureFamily();

/// See also [chatThreadFuture].
class ChatThreadFutureFamily extends Family<AsyncValue<Thread?>> {
  /// See also [chatThreadFuture].
  const ChatThreadFutureFamily();

  /// See also [chatThreadFuture].
  ChatThreadFutureProvider call(
    String threadId,
  ) {
    return ChatThreadFutureProvider(
      threadId,
    );
  }

  @override
  ChatThreadFutureProvider getProviderOverride(
    covariant ChatThreadFutureProvider provider,
  ) {
    return call(
      provider.threadId,
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
  String? get name => r'chatThreadFutureProvider';
}

/// See also [chatThreadFuture].
class ChatThreadFutureProvider extends AutoDisposeFutureProvider<Thread?> {
  /// See also [chatThreadFuture].
  ChatThreadFutureProvider(
    String threadId,
  ) : this._internal(
          (ref) => chatThreadFuture(
            ref as ChatThreadFutureRef,
            threadId,
          ),
          from: chatThreadFutureProvider,
          name: r'chatThreadFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatThreadFutureHash,
          dependencies: ChatThreadFutureFamily._dependencies,
          allTransitiveDependencies:
              ChatThreadFutureFamily._allTransitiveDependencies,
          threadId: threadId,
        );

  ChatThreadFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadId,
  }) : super.internal();

  final String threadId;

  @override
  Override overrideWith(
    FutureOr<Thread?> Function(ChatThreadFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatThreadFutureProvider._internal(
        (ref) => create(ref as ChatThreadFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threadId: threadId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Thread?> createElement() {
    return _ChatThreadFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatThreadFutureProvider && other.threadId == threadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatThreadFutureRef on AutoDisposeFutureProviderRef<Thread?> {
  /// The parameter `threadId` of this provider.
  String get threadId;
}

class _ChatThreadFutureProviderElement
    extends AutoDisposeFutureProviderElement<Thread?> with ChatThreadFutureRef {
  _ChatThreadFutureProviderElement(super.provider);

  @override
  String get threadId => (origin as ChatThreadFutureProvider).threadId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
