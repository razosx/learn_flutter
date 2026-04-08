import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/models/random_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'liked_users_provider.g.dart';

/// Notifier que mantiene el conjunto global de usuarios con like.
/// Usa [Set] para evitar duplicados por referencia de objeto.
@riverpod
class LikedUsersNotifier extends _$LikedUsersNotifier {

  @override
  Set<RandomUser> build() => {};

  /// Agrega [user] al set si aún no está presente.
  void addLikedUser(RandomUser user) {
    if (!state.contains(user)) state = {...state, user};
  }

  /// Elimina [user] del set comparando por [username].
  void removeLikedUser(RandomUser user) {
    state = state.where((u) => u.login.username != user.login.username).toSet();
  }
}

/// Notifier que controla la animación "+1" al dar like.
/// Se activa con [animate] y se autoreset tras 500ms.
@riverpod
class AnimateP1 extends _$AnimateP1 {
  @override
  bool build() => false;

  /// Activa la animación y la apaga automáticamente después de 500ms.
  void animate() {
    state = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (ref.mounted) {
        state = false;
      }
    });
  }
}

/// Notifier que controla la animación "−" al dar dislike.
/// Mismo patrón que [AnimateP1].
@riverpod
class AnimateMinus extends _$AnimateMinus {
  @override
  bool build() => false;

  /// Activa la animación y la apaga automáticamente después de 500ms.
  void animate() {
    state = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (ref.mounted) {
        state = false;
      }
    });
  }
}