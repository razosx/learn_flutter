import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_bloc.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_event.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_state.dart';
import 'package:store/models/random_user.dart';
import 'package:store/riverpod/utils/enums.dart';

class RandomUserCardWidgetBloc extends StatelessWidget {
  final RandomUser randomUser;
  final int index;

  const RandomUserCardWidgetBloc({
    super.key,
    required this.randomUser,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikedUsersBloc, LikedUsersState>(
      buildWhen: (prev, curr) =>
          prev.likeStateForIndex(index) != curr.likeStateForIndex(index),
      builder: (context, state) {
        final likeState = state.likeStateForIndex(index);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  randomUser.login.username,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.biggest.shortestSide;
                      return CircleAvatar(
                        radius: size / 2,
                        backgroundImage: NetworkImage(randomUser.picture.large),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  randomUser.name.first,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  randomUser.email,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  randomUser.location.country,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (likeState != LikeState.liked) {
                          context.read<LikedUsersBloc>().add(
                                AddLikedUserEvent(
                                    user: randomUser, index: index),
                              );
                        }
                      },
                      icon: Icon(
                        Icons.thumb_up,
                        color:
                            likeState == LikeState.liked ? Colors.green : null,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (likeState == LikeState.liked) {
                          context.read<LikedUsersBloc>().add(
                                RemoveLikedUserEvent(
                                    user: randomUser, index: index),
                              );
                        }
                      },
                      icon: Icon(
                        Icons.thumb_down,
                        color:
                            likeState == LikeState.disliked ? Colors.red : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
