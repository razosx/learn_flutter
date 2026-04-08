import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_event.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_state.dart';
import 'package:store/riverpod/utils/enums.dart';

/// BLoC que gestiona los likes, el estado por card y las animaciones de feedback.
/// Unifica en un solo lugar lo que en Riverpod eran tres providers separados:
/// [likedUsersProvider], [randomUserStateProvider] y los dos animation providers.
class LikedUsersBloc extends Bloc<LikedUsersEvent, LikedUsersState> {
  LikedUsersBloc() : super(const LikedUsersState()) {
    on<AddLikedUserEvent>(_onAddLikedUser);
    on<RemoveLikedUserEvent>(_onRemoveLikedUser);
    on<ResetAnimationEvent>(_onResetAnimation);
  }

  /// Agrega el usuario al set de likes y marca la card en [LikeState.liked].
  /// La deduplicación se hace por [uuid] ya que [RandomUser] no implementa ==.
  /// Activa [animateP1] para que el widget reproduzca la animación "+1".
  void _onAddLikedUser(AddLikedUserEvent event, Emitter<LikedUsersState> emit) {
    // Si el usuario ya tiene like, ignorar el evento para evitar duplicados.
    if (state.isLiked(event.user.login.uuid)) return;

    final updatedUsers = [...state.likedUsers, event.user];
    final updatedStates = Map<int, LikeState>.from(state.likeStates)
      ..[event.index] = LikeState.liked;

    emit(state.copyWith(
      likedUsers: updatedUsers,
      likeStates: updatedStates,
      animateP1: true,
    ));
  }

  /// Elimina el usuario del set de likes y marca la card en [LikeState.disliked].
  /// Si el usuario no tenía like previo, el evento es ignorado (no-op).
  /// Activa [animateMinus] para que el widget reproduzca la animación "−".
  void _onRemoveLikedUser(
      RemoveLikedUserEvent event, Emitter<LikedUsersState> emit) {
    // Solo procesar si el usuario realmente estaba en liked.
    final wasLiked = state.isLiked(event.user.login.uuid);
    if (!wasLiked) return;

    final updatedUsers = state.likedUsers
        .where((u) => u.login.uuid != event.user.login.uuid)
        .toList();
    final updatedStates = Map<int, LikeState>.from(state.likeStates)
      ..[event.index] = LikeState.disliked;

    emit(state.copyWith(
      likedUsers: updatedUsers,
      likeStates: updatedStates,
      animateMinus: true,
    ));
  }

  /// Resetea ambos flags de animación a false.
  /// El widget lo dispara mediante un [Future.delayed] de 500ms tras activarse
  /// la animación, evitando que el BLoC maneje timers internamente.
  void _onResetAnimation(
      ResetAnimationEvent event, Emitter<LikedUsersState> emit) {
    emit(state.copyWith(animateP1: false, animateMinus: false));
  }
}
