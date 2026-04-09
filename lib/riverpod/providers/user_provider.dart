import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store/models/random_user.dart';
import 'package:store/networking/dio_util.dart';
import 'package:store/riverpod/utils/enums.dart';

part 'user_provider.g.dart';

/// Provider que obtiene 10 usuarios aleatorios desde la API.
/// Al ser un [FutureProvider], expone estados [AsyncLoading], [AsyncData] y [AsyncError]
/// que la UI consume con pattern matching.
@riverpod
Future<List<RandomUser>> randomUserList(ref) async {
  print('Fetching random users...');
  return await fetchRandomUsers(10);
}

/// Provider de familia que mantiene el [LikeState] de cada card por su [index].
/// [keepAlive: true] evita que el estado se pierda al salir y volver a la pantalla.
@Riverpod(keepAlive: true)
class RandomUserState extends _$RandomUserState {

  @override
  LikeState build(int index) {
    return LikeState.neutral;
  }

  /// Actualiza el estado de like de la card en este índice.
  void changeLikeState(LikeState newState) {
    state = newState;
  }
}