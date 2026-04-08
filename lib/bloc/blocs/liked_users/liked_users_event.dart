import 'package:equatable/equatable.dart';
import 'package:store/models/random_user.dart';

abstract class LikedUsersEvent extends Equatable {
  const LikedUsersEvent();

  @override
  List<Object?> get props => [];
}

class AddLikedUserEvent extends LikedUsersEvent {
  final RandomUser user;
  final int index;

  const AddLikedUserEvent({required this.user, required this.index});

  @override
  List<Object?> get props => [user.login.uuid, index];
}

class RemoveLikedUserEvent extends LikedUsersEvent {
  final RandomUser user;
  final int index;

  const RemoveLikedUserEvent({required this.user, required this.index});

  @override
  List<Object?> get props => [user.login.uuid, index];
}

class ResetAnimationEvent extends LikedUsersEvent {
  const ResetAnimationEvent();
}
