import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_bloc.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_event.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_state.dart';
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
          thumbnail: 'https://example.com/t.jpg'),
      nat: 'MX',
    );

final _user0 = _mockUser('uuid-0', 'alice');
final _user1 = _mockUser('uuid-1', 'bob');
final _user2 = _mockUser('uuid-2', 'carol');

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('LikedUsersBloc', () {
    late LikedUsersBloc bloc;

    setUp(() => bloc = LikedUsersBloc());
    tearDown(() => bloc.close());

    test('initial state has empty likedUsers, likeStates and animations false',
        () {
      expect(bloc.state.likedUsers, isEmpty);
      expect(bloc.state.likeStates, isEmpty);
      expect(bloc.state.animateP1, isFalse);
      expect(bloc.state.animateMinus, isFalse);
    });

    blocTest<LikedUsersBloc, LikedUsersState>(
      'AddLikedUserEvent adds user, sets likeState to liked, animateP1 true',
      build: () => LikedUsersBloc(),
      act: (bloc) =>
          bloc.add(AddLikedUserEvent(user: _user0, index: 0)),
      verify: (bloc) {
        final state = bloc.state;
        expect(state.likedUsers, contains(_user0));
        expect(state.likeStateForIndex(0), LikeState.liked);
        expect(state.animateP1, isTrue);
      },
    );

    blocTest<LikedUsersBloc, LikedUsersState>(
      'AddLikedUserEvent duplicate is a no-op',
      build: () => LikedUsersBloc(),
      act: (bloc) {
        bloc.add(AddLikedUserEvent(user: _user0, index: 0));
        bloc.add(AddLikedUserEvent(user: _user0, index: 0));
      },
      verify: (bloc) {
        expect(bloc.state.likedUsers.length, 1);
      },
    );

    blocTest<LikedUsersBloc, LikedUsersState>(
      'RemoveLikedUserEvent removes liked user, sets disliked, animateMinus true',
      build: () => LikedUsersBloc(),
      act: (bloc) {
        bloc.add(AddLikedUserEvent(user: _user0, index: 0));
        bloc.add(RemoveLikedUserEvent(user: _user0, index: 0));
      },
      verify: (bloc) {
        final state = bloc.state;
        expect(state.likedUsers, isEmpty);
        expect(state.likeStateForIndex(0), LikeState.disliked);
        expect(state.animateMinus, isTrue);
      },
    );

    blocTest<LikedUsersBloc, LikedUsersState>(
      'RemoveLikedUserEvent on non-liked user is a no-op',
      build: () => LikedUsersBloc(),
      act: (bloc) =>
          bloc.add(RemoveLikedUserEvent(user: _user0, index: 0)),
      expect: () => [],
    );

    blocTest<LikedUsersBloc, LikedUsersState>(
      'ResetAnimationEvent sets both animation flags to false',
      build: () => LikedUsersBloc(),
      act: (bloc) {
        bloc.add(AddLikedUserEvent(user: _user0, index: 0));
        bloc.add(const ResetAnimationEvent());
      },
      verify: (bloc) {
        expect(bloc.state.animateP1, isFalse);
        expect(bloc.state.animateMinus, isFalse);
      },
    );

    blocTest<LikedUsersBloc, LikedUsersState>(
      'indices are independent: index 0 liked, index 1 disliked, index 2 neutral',
      build: () => LikedUsersBloc(),
      act: (bloc) {
        bloc.add(AddLikedUserEvent(user: _user0, index: 0));
        bloc.add(AddLikedUserEvent(user: _user1, index: 1));
        bloc.add(RemoveLikedUserEvent(user: _user1, index: 1));
      },
      verify: (bloc) {
        expect(bloc.state.likeStateForIndex(0), LikeState.liked);
        expect(bloc.state.likeStateForIndex(1), LikeState.disliked);
        expect(bloc.state.likeStateForIndex(2), LikeState.neutral);
      },
    );

    test('isLiked returns true only for users in likedUsers', () async {
      bloc.add(AddLikedUserEvent(user: _user0, index: 0));
      await Future.delayed(Duration.zero);
      expect(bloc.state.isLiked(_user0.login.uuid), isTrue);
      expect(bloc.state.isLiked(_user2.login.uuid), isFalse);
    });
  });
}
