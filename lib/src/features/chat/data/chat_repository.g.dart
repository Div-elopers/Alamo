// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'7ab66dee8488642a07e0951b2b4e8f23c9218c0b';

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
String _$chatStreamHash() => r'1d9f224c1ade194de6d2d5c07e86f5c53b6a5e24';

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

/// See also [chatStream].
@ProviderFor(chatStream)
const chatStreamProvider = ChatStreamFamily();

/// See also [chatStream].
class ChatStreamFamily extends Family<AsyncValue<Chat?>> {
  /// See also [chatStream].
  const ChatStreamFamily();

  /// See also [chatStream].
  ChatStreamProvider call(
    String chatId,
  ) {
    return ChatStreamProvider(
      chatId,
    );
  }

  @override
  ChatStreamProvider getProviderOverride(
    covariant ChatStreamProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'chatStreamProvider';
}

/// See also [chatStream].
class ChatStreamProvider extends AutoDisposeStreamProvider<Chat?> {
  /// See also [chatStream].
  ChatStreamProvider(
    String chatId,
  ) : this._internal(
          (ref) => chatStream(
            ref as ChatStreamRef,
            chatId,
          ),
          from: chatStreamProvider,
          name: r'chatStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatStreamHash,
          dependencies: ChatStreamFamily._dependencies,
          allTransitiveDependencies:
              ChatStreamFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    Stream<Chat?> Function(ChatStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatStreamProvider._internal(
        (ref) => create(ref as ChatStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Chat?> createElement() {
    return _ChatStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatStreamProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatStreamRef on AutoDisposeStreamProviderRef<Chat?> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatStreamProviderElement extends AutoDisposeStreamProviderElement<Chat?>
    with ChatStreamRef {
  _ChatStreamProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatStreamProvider).chatId;
}

String _$chatFutureHash() => r'e35cc85dea28d91f02e6817e82fbf4f9b5bd1dc6';

/// See also [chatFuture].
@ProviderFor(chatFuture)
const chatFutureProvider = ChatFutureFamily();

/// See also [chatFuture].
class ChatFutureFamily extends Family<AsyncValue<Chat?>> {
  /// See also [chatFuture].
  const ChatFutureFamily();

  /// See also [chatFuture].
  ChatFutureProvider call(
    String chatId,
  ) {
    return ChatFutureProvider(
      chatId,
    );
  }

  @override
  ChatFutureProvider getProviderOverride(
    covariant ChatFutureProvider provider,
  ) {
    return call(
      provider.chatId,
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
  String? get name => r'chatFutureProvider';
}

/// See also [chatFuture].
class ChatFutureProvider extends AutoDisposeFutureProvider<Chat?> {
  /// See also [chatFuture].
  ChatFutureProvider(
    String chatId,
  ) : this._internal(
          (ref) => chatFuture(
            ref as ChatFutureRef,
            chatId,
          ),
          from: chatFutureProvider,
          name: r'chatFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatFutureHash,
          dependencies: ChatFutureFamily._dependencies,
          allTransitiveDependencies:
              ChatFutureFamily._allTransitiveDependencies,
          chatId: chatId,
        );

  ChatFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chatId,
  }) : super.internal();

  final String chatId;

  @override
  Override overrideWith(
    FutureOr<Chat?> Function(ChatFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChatFutureProvider._internal(
        (ref) => create(ref as ChatFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chatId: chatId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Chat?> createElement() {
    return _ChatFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatFutureProvider && other.chatId == chatId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chatId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatFutureRef on AutoDisposeFutureProviderRef<Chat?> {
  /// The parameter `chatId` of this provider.
  String get chatId;
}

class _ChatFutureProviderElement extends AutoDisposeFutureProviderElement<Chat?>
    with ChatFutureRef {
  _ChatFutureProviderElement(super.provider);

  @override
  String get chatId => (origin as ChatFutureProvider).chatId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
