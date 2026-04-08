// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_users_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LikedUsersNotifier)
final likedUsersProvider = LikedUsersNotifierProvider._();

final class LikedUsersNotifierProvider
    extends $NotifierProvider<LikedUsersNotifier, Set<RandomUser>> {
  LikedUsersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likedUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likedUsersNotifierHash();

  @$internal
  @override
  LikedUsersNotifier create() => LikedUsersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<RandomUser> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<RandomUser>>(value),
    );
  }
}

String _$likedUsersNotifierHash() =>
    r'637b706aea47e84579ce3badb14a994b30965666';

abstract class _$LikedUsersNotifier extends $Notifier<Set<RandomUser>> {
  Set<RandomUser> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<RandomUser>, Set<RandomUser>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<RandomUser>, Set<RandomUser>>,
              Set<RandomUser>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Animate the +1 when liking a user

@ProviderFor(AnimateP1)
final animateP1Provider = AnimateP1Provider._();

/// Animate the +1 when liking a user
final class AnimateP1Provider extends $NotifierProvider<AnimateP1, bool> {
  /// Animate the +1 when liking a user
  AnimateP1Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'animateP1Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$animateP1Hash();

  @$internal
  @override
  AnimateP1 create() => AnimateP1();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$animateP1Hash() => r'030da2b511cbeb1be5f633cd3b06b5bb9ab767cf';

/// Animate the +1 when liking a user

abstract class _$AnimateP1 extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Animate the - when disliking a user

@ProviderFor(AnimateMinus)
final animateMinusProvider = AnimateMinusProvider._();

/// Animate the - when disliking a user
final class AnimateMinusProvider extends $NotifierProvider<AnimateMinus, bool> {
  /// Animate the - when disliking a user
  AnimateMinusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'animateMinusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$animateMinusHash();

  @$internal
  @override
  AnimateMinus create() => AnimateMinus();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$animateMinusHash() => r'f78c63fe0157f2aec39b8cc1bd2e57590ffe9c32';

/// Animate the - when disliking a user

abstract class _$AnimateMinus extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
