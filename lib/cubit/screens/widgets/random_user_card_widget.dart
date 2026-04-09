import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/cubit/cubits/liked_users/liked_users_cubit.dart';
import 'package:store/cubit/cubits/liked_users/liked_users_state.dart';
import 'package:store/models/random_user.dart';
import 'package:store/riverpod/utils/enums.dart';

class RandomUserCardWidgetCubit extends StatelessWidget {
  final RandomUser randomUser;
  final int index;

  const RandomUserCardWidgetCubit({
    super.key,
    required this.randomUser,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikedUsersCubit, LikedUsersCubitState>(
      // Solo reconstruye cuando el estado de like de esta card cambia,
      // evitando rebuilds innecesarios en el resto del grid.
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
                          // Cubit: llama método directamente, sin eventos
                          context
                              .read<LikedUsersCubit>()
                              .addLikedUser(randomUser, index);
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
                          // Cubit: llama método directamente, sin eventos
                          context
                              .read<LikedUsersCubit>()
                              .removeLikedUser(randomUser, index);
                        }
                      },
                      icon: Icon(
                        Icons.thumb_down,
                        color: likeState == LikeState.disliked
                            ? Colors.red
                            : null,
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
