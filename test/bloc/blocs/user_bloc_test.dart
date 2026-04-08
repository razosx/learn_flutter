import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store/bloc/blocs/user/user_bloc.dart';
import 'package:store/bloc/blocs/user/user_event.dart';
import 'package:store/bloc/blocs/user/user_state.dart';
import 'package:store/bloc/repositories/user_repository.dart';
import 'package:store/models/random_user.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

RandomUser _mockUser(String uuid, String username) => RandomUser(
      gender: 'male',
      name: Name(title: 'Mr', first: 'Test', last: 'User'),
      location: Location(
        street: Street(number: 1, name: 'Main St'),
        city: 'City',
        state: 'State',
        country: 'Country',
        postcode: '00000',
      ),
      email: 'test@test.com',
      login: Login(
        uuid: uuid,
        username: username,
        password: 'pass',
        salt: 'salt',
        md5: 'md5',
        sha1: 'sha1',
        sha256: 'sha256',
      ),
      dob: DateTime(1990),
      age: 34,
      registered: DateTime(2010),
      phone: '000',
      cell: '000',
      picture: Picture(
          large: 'https://example.com/l.jpg',
          medium: 'https://example.com/m.jpg',
          thumbnail: 'https://example.com/t.jpg'),
      nat: 'US',
    );

final _mockUsers = [_mockUser('uuid-1', 'user1'), _mockUser('uuid-2', 'user2')];

// ---------------------------------------------------------------------------
// Fake repositories
// ---------------------------------------------------------------------------

class FakeUserRepository implements UserRepository {
  @override
  Future<List<RandomUser>> fetchUsers(int count) async => _mockUsers;
}

class FailingUserRepository implements UserRepository {
  @override
  Future<List<RandomUser>> fetchUsers(int count) async =>
      throw Exception('Network error');
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserBloc', () {
    test('initial state is UserInitial', () {
      final bloc = UserBloc(repository: FakeUserRepository());
      expect(bloc.state, const UserInitial());
      bloc.close();
    });

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserLoaded] on FetchUsersEvent success',
      build: () => UserBloc(repository: FakeUserRepository()),
      act: (bloc) => bloc.add(const FetchUsersEvent()),
      expect: () => [
        const UserLoading(),
        UserLoaded(_mockUsers),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserError] on FetchUsersEvent failure',
      build: () => UserBloc(repository: FailingUserRepository()),
      act: (bloc) => bloc.add(const FetchUsersEvent()),
      expect: () => [
        const UserLoading(),
        isA<UserError>(),
      ],
    );

    test('two UserLoaded with the same list instance are equal', () {
      expect(UserLoaded(_mockUsers), UserLoaded(_mockUsers));
    });
  });
}
