import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store/cubit/cubits/liked_users/liked_users_cubit.dart';
import 'package:store/cubit/cubits/liked_users/liked_users_state.dart';
import 'package:store/models/random_user.dart';
import 'package:store/riverpod/utils/enums.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

RandomUser _mockUser(String uuid, String username) => RandomUser(
      gender: 'female',
      name: Name(title: 'Ms', first: 'Jane', last: 'Doe'),
      location: Location(
        street: Street(number: 1, name: 'Main St'),
        city: 'City',
        state: 'State',
        country: 'Country',
        postcode: '00000',
      ),
      email: 'jane@test.com',
      login: Login(
        uuid: uuid,
        username: username,
        password: 'pass',
        salt: 'salt',
        md5: 'md5',
        sha1: 'sha1',
        sha256: 'sha256',
      ),
      dob: DateTime(1995),
      age: 29,
      registered: DateTime(2015),
      phone: '000',
      cell: '000',
      picture: Picture(
        large: 'https://example.com/l.jpg',
        medium: 'https://example.com/m.jpg',
        thumbnail: 'https://example.com/t.jpg',
      ),
      nat: 'MX',
    );

final _user0 = _mockUser('uuid-0', 'alice');
final _user1 = _mockUser('uuid-1', 'bob');
final _user2 = _mockUser('uuid-2', 'carol');

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('LikedUsersCubit', () {
    late LikedUsersCubit cubit;

    setUp(() => cubit = LikedUsersCubit());
    tearDown(() => cubit.close());

    test('estado inicial tiene likedUsers vacío, likeStates vacío y animaciones false',
        () {
      expect(cubit.state.likedUsers, isEmpty);
      expect(cubit.state.likeStates, isEmpty);
      expect(cubit.state.animateP1, isFalse);
      expect(cubit.state.animateMinus, isFalse);
    });

    blocTest<LikedUsersCubit, LikedUsersCubitState>(
      'addLikedUser() agrega usuario, marca likeState como liked y activa animateP1',
      build: () => LikedUsersCubit(),
      act: (cubit) => cubit.addLikedUser(_user0, 0),
      verify: (cubit) {
        final state = cubit.state;
        expect(state.likedUsers, contains(_user0));
        expect(state.likeStateForIndex(0), LikeState.liked);
        expect(state.animateP1, isTrue);
      },
    );

    blocTest<LikedUsersCubit, LikedUsersCubitState>(
      'addLikedUser() duplicado es un no-op',
      build: () => LikedUsersCubit(),
      act: (cubit) {
        cubit.addLikedUser(_user0, 0);
        cubit.addLikedUser(_user0, 0);
      },
      verify: (cubit) {
        expect(cubit.state.likedUsers.length, 1);
      },
    );

    blocTest<LikedUsersCubit, LikedUsersCubitState>(
      'removeLikedUser() elimina usuario liked, marca disliked y activa animateMinus',
      build: () => LikedUsersCubit(),
      act: (cubit) {
        cubit.addLikedUser(_user0, 0);
        cubit.removeLikedUser(_user0, 0);
      },
      verify: (cubit) {
        final state = cubit.state;
        expect(state.likedUsers, isEmpty);
        expect(state.likeStateForIndex(0), LikeState.disliked);
        expect(state.animateMinus, isTrue);
      },
    );

    blocTest<LikedUsersCubit, LikedUsersCubitState>(
      'removeLikedUser() sobre usuario no liked es un no-op',
      build: () => LikedUsersCubit(),
      act: (cubit) => cubit.removeLikedUser(_user0, 0),
      expect: () => [],
    );

    blocTest<LikedUsersCubit, LikedUsersCubitState>(
      'resetAnimation() pone ambas flags de animación en false',
      build: () => LikedUsersCubit(),
      act: (cubit) {
        cubit.addLikedUser(_user0, 0);
        cubit.resetAnimation();
      },
      verify: (cubit) {
        expect(cubit.state.animateP1, isFalse);
        expect(cubit.state.animateMinus, isFalse);
      },
    );

    blocTest<LikedUsersCubit, LikedUsersCubitState>(
      'los índices son independientes: índice 0 liked, índice 1 disliked, índice 2 neutral',
      build: () => LikedUsersCubit(),
      act: (cubit) {
        cubit.addLikedUser(_user0, 0);
        cubit.addLikedUser(_user1, 1);
        cubit.removeLikedUser(_user1, 1);
      },
      verify: (cubit) {
        expect(cubit.state.likeStateForIndex(0), LikeState.liked);
        expect(cubit.state.likeStateForIndex(1), LikeState.disliked);
        expect(cubit.state.likeStateForIndex(2), LikeState.neutral);
      },
    );

    test('isLiked() retorna true solo para usuarios en likedUsers', () async {
      cubit.addLikedUser(_user0, 0);
      await Future.delayed(Duration.zero);
      expect(cubit.state.isLiked(_user0.login.uuid), isTrue);
      expect(cubit.state.isLiked(_user2.login.uuid), isFalse);
    });
  });
}
