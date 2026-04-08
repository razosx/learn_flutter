import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/models/random_user.dart';
import 'package:store/riverpod/providers/liked_users_provider.dart';
import 'package:store/riverpod/providers/user_provider.dart';
import 'package:store/riverpod/utils/enums.dart';

class RandomUserCardWidget extends ConsumerStatefulWidget {
  final RandomUser randomUser;
  final int index;
  // LikeState likeState = LikeState.neutral;

  const RandomUserCardWidget({super.key, required this.randomUser, required this.index});

  @override
  ConsumerState<RandomUserCardWidget> createState() => _RandomUserCardWidgetState();
}

class _RandomUserCardWidgetState extends ConsumerState<RandomUserCardWidget> {
  @override
  Widget build(BuildContext context) {
    final likedUsers = ref.watch(likedUsersProvider);
    final liked = ref.watch(randomUserStateProvider(widget.index));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              widget.randomUser.login.username,
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
                    backgroundImage: NetworkImage(widget.randomUser.picture.large),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.randomUser.name.first,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.randomUser.email,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              widget.randomUser.location.country,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if(!likedUsers.contains(widget.randomUser)){
                      ref.read(likedUsersProvider.notifier).addLikedUser(widget.randomUser); // Add to liked users if not currently liked
                      ref.read(randomUserStateProvider(widget.index).notifier).changeLikeState(LikeState.liked); // Change state to liked  
                    }

                  },
                  icon: Icon(Icons.thumb_up,
                      color: liked == LikeState.liked ? Colors.green : null
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if(likedUsers.contains(widget.randomUser)){
                      ref.read(likedUsersProvider.notifier).removeLikedUser(widget.randomUser); // Remove from liked users if currently liked
                      ref.read(randomUserStateProvider(widget.index).notifier).changeLikeState(LikeState.disliked); // Change state to disliked
                    }else{
                      print("Adding disliked user"); 
                    }
                  },
                  icon: Icon(Icons.thumb_down,
                    color: liked == LikeState.disliked ? Colors.red : null
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
