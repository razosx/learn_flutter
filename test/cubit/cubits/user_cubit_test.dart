import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store/bloc/repositories/user_repository.dart';
import 'package:store/cubit/cubits/user/user_cubit.dart';
import 'package:store/cubit/cubits/user/user_state.dart';
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
        thumbnail: 'https://example.com/t.jpg',
      ),
      nat: 'US',
    );

final _mockUsers = [_mockUser('uuid-1', 'user1'), _mockUser('uuid-2', 'user2')];

// ---------------------------------------------------------------------------
// Fake repositories
// ---------------------------------------------------------------------------

/// Repositorio fake que retorna datos mock sin red.
class FakeUserRepository implements UserRepository {
  @override
  Future<List<RandomUser>> fetchUsers(int count) async => _mockUsers;
}

/// Repositorio fake que simula un error de red.
class FailingUserRepository implements UserRepository {
  @override
  Future<List<RandomUser>> fetchUsers(int count) async =>
      throw Exception('Network error');
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UserCubit', () {
    test('initial state is UserCubitInitial', () {
      final cubit = UserCubit(repository: FakeUserRepository());
      expect(cubit.state, const UserCubitInitial());
      cubit.close();
    });

    blocTest<UserCubit, UserCubitState>(
      'fetchUsers() emite [UserCubitLoading, UserCubitLoaded] cuando la llamada es exitosa',
      build: () => UserCubit(repository: FakeUserRepository()),
      act: (cubit) => cubit.fetchUsers(),
      expect: () => [
        const UserCubitLoading(),
        UserCubitLoaded(_mockUsers),
      ],
    );

    blocTest<UserCubit, UserCubitState>(
      'fetchUsers() emite [UserCubitLoading, UserCubitError] cuando la llamada falla',
      build: () => UserCubit(repository: FailingUserRepository()),
      act: (cubit) => cubit.fetchUsers(),
      expect: () => [
        const UserCubitLoading(),
        isA<UserCubitError>(),
      ],
    );

    test('dos UserCubitLoaded con la misma instancia de lista son iguales', () {
      expect(UserCubitLoaded(_mockUsers), UserCubitLoaded(_mockUsers));
    });
  });
}
