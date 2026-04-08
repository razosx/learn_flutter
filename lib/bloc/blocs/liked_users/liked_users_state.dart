import 'package:equatable/equatable.dart';
import 'package:store/models/random_user.dart';
import 'package:store/riverpod/utils/enums.dart';

/// Estado único de [LikedUsersBloc].
/// Centraliza en un solo objeto lo que en Riverpod eran tres providers separados:
/// la colección de usuarios con like, el estado por índice y los flags de animación.
class LikedUsersState extends Equatable {
  /// Lista de usuarios a los que el usuario dio like.
  final List<RandomUser> likedUsers;

  /// Mapa de índice de card → [LikeState]. Los índices ausentes son [LikeState.neutral].
  final Map<int, LikeState> likeStates;

  /// Indica que debe reproducirse la animación "+1" (like recién añadido).
  final bool animateP1;

  /// Indica que debe reproducirse la animación "−" (like recién eliminado).
  final bool animateMinus;

  const LikedUsersState({
    this.likedUsers = const [],
    this.likeStates = const {},
    this.animateP1 = false,
    this.animateMinus = false,
  });

  /// Retorna el [LikeState] de la card en [index], o [LikeState.neutral] si aún
  /// no fue interactuada.
  LikeState likeStateForIndex(int index) =>
      likeStates[index] ?? LikeState.neutral;

  /// Comprueba si el usuario con [uuid] ya está en la lista de likes.
  /// Se usa [uuid] en lugar de referencia de objeto porque [RandomUser] no
  /// implementa == / hashCode.
  bool isLiked(String uuid) =>
      likedUsers.any((u) => u.login.uuid == uuid);

  /// Crea una copia del estado reemplazando solo los campos proporcionados.
  LikedUsersState copyWith({
    List<RandomUser>? likedUsers,
    Map<int, LikeState>? likeStates,
    bool? animateP1,
    bool? animateMinus,
  }) {
    return LikedUsersState(
      likedUsers: likedUsers ?? this.likedUsers,
      likeStates: likeStates ?? this.likeStates,
      animateP1: animateP1 ?? this.animateP1,
      animateMinus: animateMinus ?? this.animateMinus,
    );
  }

  @override
  List<Object?> get props => [likedUsers, likeStates, animateP1, animateMinus];
}
