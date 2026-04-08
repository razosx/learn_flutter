// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(randomUserList)
final randomUserListProvider = RandomUserListProvider._();

final class RandomUserListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RandomUser>>,
          List<RandomUser>,
          FutureOr<List<RandomUser>>
        >
    with $FutureModifier<List<RandomUser>>, $FutureProvider<List<RandomUser>> {
  RandomUserListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'randomUserListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$randomUserListHash();

  @$internal
  @override
  $FutureProviderElement<List<RandomUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RandomUser>> create(Ref ref) {
    return randomUserList(ref);
  }
}

String _$randomUserListHash() => r'b0d16307166492861e80edfc78eba63d7103fab0';

@ProviderFor(RandomUserState)
final randomUserStateProvider = RandomUserStateFamily._();

final class RandomUserStateProvider
    extends $NotifierProvider<RandomUserState, LikeState> {
  RandomUserStateProvider._({
    required RandomUserStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'randomUserStateProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$randomUserStateHash();

  @override
  String toString() {
    return r'randomUserStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RandomUserState create() => RandomUserState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LikeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LikeState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RandomUserStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$randomUserStateHash() => r'50d195db84104e813860b898c7e18fd5942a589d';

final class RandomUserStateFamily extends $Family
    with
        $ClassFamilyOverride<
          RandomUserState,
          LikeState,
          LikeState,
          LikeState,
          int
        > {
  RandomUserStateFamily._()
    : super(
        retry: null,
        name: r'randomUserStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RandomUserStateProvider call(int index) =>
      RandomUserStateProvider._(argument: index, from: this);

  @override
  String toString() => r'randomUserStateProvider';
}

abstract class _$RandomUserState extends $Notifier<LikeState> {
  late final _$args = ref.$arg as int;
  int get index => _$args;

  LikeState build(int index);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LikeState, LikeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LikeState, LikeState>,
              LikeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
