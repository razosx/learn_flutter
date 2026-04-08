import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/models/random_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'liked_users_provider.g.dart';

@riverpod
class LikedUsersNotifier extends _$LikedUsersNotifier {

  // Initialize with an empty set of liked users
  @override
  Set<RandomUser> build() => {};

  void addLikedUser(RandomUser user) {
    // Add a user to the liked users set
    if (!state.contains(user)) state = {...state, user};
  }

  void removeLikedUser(RandomUser user) {
    // Remove a user from the liked users set
    state = state.where((u) => u.login.username != user.login.username).toSet();
  }
}

/// Animate the +1 when liking a user
@riverpod
class AnimateP1 extends _$AnimateP1 {
  @override
  bool build() => false;

  void animate() {
    state = true; // Trigger animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (ref.mounted) {
        state = false; // Reset after animation duration
      }
    });
  }
}
/// Animate the - when disliking a user
@riverpod
class AnimateMinus extends _$AnimateMinus {
  @override
  bool build() => false;

  void animate() {
    state = true; // Trigger animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (ref.mounted) {
        state = false; // Reset after animation duration
      }
    });
  }
}