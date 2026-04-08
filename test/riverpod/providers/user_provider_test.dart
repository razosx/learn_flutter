import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/riverpod/providers/user_provider.dart';
import 'package:store/riverpod/utils/enums.dart';

void main() {
  group('RandomUserState tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state for a given index is LikeState.neutral', () {
      final state = container.read(randomUserStateProvider(0));
      expect(state, LikeState.neutral);
    });

    test('changeLikeState updates the state correctly', () {
      final notifier = container.read(randomUserStateProvider(0).notifier);
      
      notifier.changeLikeState(LikeState.liked);
      expect(container.read(randomUserStateProvider(0)), LikeState.liked);
      
      notifier.changeLikeState(LikeState.disliked);
      expect(container.read(randomUserStateProvider(0)), LikeState.disliked);
    });

    test('different indices have independent states', () {
      container.read(randomUserStateProvider(0).notifier).changeLikeState(LikeState.liked);
      container.read(randomUserStateProvider(1).notifier).changeLikeState(LikeState.disliked);
      
      expect(container.read(randomUserStateProvider(0)), LikeState.liked);
      expect(container.read(randomUserStateProvider(1)), LikeState.disliked);
      expect(container.read(randomUserStateProvider(2)), LikeState.neutral);
    });
  });

  group('randomUserListProvider tests', () {
    test('can be overridden with mock data', () async {
      final container = ProviderContainer(
        overrides: [
          randomUserListProvider.overrideWith((ref) async => []),
        ],
      );
      
      final result = await container.read(randomUserListProvider.future);
      expect(result, isEmpty);
      
      container.dispose();
    });
  });
}
