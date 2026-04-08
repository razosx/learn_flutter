import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/models/random_user.dart';
import 'package:store/riverpod/providers/liked_users_provider.dart';

void main() {
  group('LikedUsersNotifier tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    final mockUser = RandomUser(
      gender: 'male',
      name: Name(title: 'Mr', first: 'John', last: 'Doe'),
      location: Location(
        street: Street(number: 123, name: 'Main St'),
        city: 'Springfield',
        state: 'Illinois',
        country: 'USA',
        postcode: '62704',
      ),
      email: 'john.doe@example.com',
      login: Login(
        uuid: '1', 
        username: 'johndoe', 
        password: 'password', 
        salt: 'salt', 
        md5: 'md5', 
        sha1: 'sha1', 
        sha256: 'sha256'
      ),
      dob: DateTime(1990, 1, 1),
      age: 30,
      registered: DateTime(2020, 1, 1),
      phone: '123-456-7890',
      cell: '098-765-4321',
      picture: Picture(large: '', medium: '', thumbnail: ''),
      nat: 'US',
    );

    test('initial state is an empty set', () {
      final state = container.read(likedUsersProvider);
      expect(state, isEmpty);
    });

    test('addLikedUser adds a user to the state', () {
      container.read(likedUsersProvider.notifier).addLikedUser(mockUser);
      final state = container.read(likedUsersProvider);
      expect(state, contains(mockUser));
      expect(state.length, 1);
    });

    test('removeLikedUser removes a user from the state', () {
      container.read(likedUsersProvider.notifier).addLikedUser(mockUser);
      container.read(likedUsersProvider.notifier).removeLikedUser(mockUser);
      final state = container.read(likedUsersProvider);
      expect(state, isNot(contains(mockUser)));
      expect(state, isEmpty);
    });
  });

  group('AnimateP1 and AnimateMinus tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('AnimateP1 initial state is false', () {
      expect(container.read(animateP1Provider), isFalse);
    });

    test('AnimateP1 animate() sets state to true and then false', () async {
      container.read(animateP1Provider.notifier).animate();
      expect(container.read(animateP1Provider), isTrue);
      
      // Wait for the duration of the animation (500ms) plus a small buffer
      await Future.delayed(const Duration(milliseconds: 550));
      expect(container.read(animateP1Provider), isFalse);
    });

    test('AnimateMinus initial state is false', () {
      expect(container.read(animateMinusProvider), isFalse);
    });

    test('AnimateMinus animate() sets state to true and then false', () async {
      container.read(animateMinusProvider.notifier).animate();
      expect(container.read(animateMinusProvider), isTrue);
      
      await Future.delayed(const Duration(milliseconds: 550));
      expect(container.read(animateMinusProvider), isFalse);
    });
  });
}
