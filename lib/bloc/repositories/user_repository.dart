import 'package:store/models/random_user.dart';
import 'package:store/networking/dio_util.dart';

/// Contrato que define cómo obtener usuarios remotos.
/// Usar una interfaz permite inyectar implementaciones fake en tests.
abstract class UserRepository {
  /// Retorna [count] usuarios aleatorios desde la fuente de datos.
  Future<List<RandomUser>> fetchUsers(int count);
}

/// Implementación real que delega la llamada HTTP a [fetchRandomUsers].
class RandomUserRepository implements UserRepository {
  const RandomUserRepository();

  @override
  Future<List<RandomUser>> fetchUsers(int count) => fetchRandomUsers(count);
}
