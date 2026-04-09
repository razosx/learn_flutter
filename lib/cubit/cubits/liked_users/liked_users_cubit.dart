import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/cubit/cubits/liked_users/liked_users_state.dart';
import 'package:store/models/random_user.dart';
import 'package:store/riverpod/utils/enums.dart';

/// Cubit que gestiona los likes, el estado por card y las animaciones de feedback.
///
/// A diferencia del [LikedUsersBloc], no define eventos: expone métodos públicos
/// ([addLikedUser], [removeLikedUser], [resetAnimation]) que los widgets llaman
/// directamente con [context.read<LikedUsersCubit>().method()].
class LikedUsersCubit extends Cubit<LikedUsersCubitState> {
  LikedUsersCubit() : super(const LikedUsersCubitState());

  /// Agrega [user] a la lista de likes y marca la card en [index] como [LikeState.liked].
  /// La deduplicación se hace por [uuid] ya que [RandomUser] no implementa ==.
  /// Activa [animateP1] para que el widget reproduzca la animación "+1".
  void addLikedUser(RandomUser user, int index) {
    // Si el usuario ya tiene like, ignorar la llamada para evitar duplicados.
    if (state.isLiked(user.login.uuid)) return;

    final updatedUsers = [...state.likedUsers, user];
    final updatedStates = Map<int, LikeState>.from(state.likeStates)
      ..[index] = LikeState.liked;

    emit(state.copyWith(
      likedUsers: updatedUsers,
      likeStates: updatedStates,
      animateP1: true,
    ));
  }

  /// Elimina [user] de la lista de likes y marca la card en [index] como [LikeState.disliked].
  /// Si el usuario no tenía like previo, la llamada es ignorada (no-op).
  /// Activa [animateMinus] para que el widget reproduzca la animación "−".
  void removeLikedUser(RandomUser user, int index) {
    // Solo procesar si el usuario realmente estaba en liked.
    if (!state.isLiked(user.login.uuid)) return;

    final updatedUsers = state.likedUsers
        .where((u) => u.login.uuid != user.login.uuid)
        .toList();
    final updatedStates = Map<int, LikeState>.from(state.likeStates)
      ..[index] = LikeState.disliked;

    emit(state.copyWith(
      likedUsers: updatedUsers,
      likeStates: updatedStates,
      animateMinus: true,
    ));
  }

  /// Resetea ambos flags de animación a false.
  /// El widget lo llama mediante un [Future.delayed] de 500ms tras activarse
  /// la animación, evitando que el Cubit maneje timers internamente.
  void resetAnimation() {
    emit(state.copyWith(animateP1: false, animateMinus: false));
  }
}
