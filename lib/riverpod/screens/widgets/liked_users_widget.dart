import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/riverpod/providers/liked_users_provider.dart';
import 'package:store/riverpod/screens/liked_users_screen.dart';

const Duration animationDuration = Duration(milliseconds: 500);

class LikedUsersWidget extends ConsumerWidget {
  const LikedUsersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedUsers = ref.watch(likedUsersProvider);
    final animateP1 = ref.watch(animateP1Provider);
    final animateMinus = ref.watch(animateMinusProvider);
    
    ref.listen(likedUsersProvider, 
    (oldState, newState){
      oldState ??= {};
      if(oldState.length > newState.length){
        ref.read(animateMinusProvider.notifier).animate();
      } else if (oldState.length < newState.length){
        ref.read(animateP1Provider.notifier).animate();
      }
    });
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LikedUsersScreen(),
              ),
            );
          },
          icon: const Icon(Icons.favorite, color: Colors.red),
        ),
        Positioned(
          left: 5,
          top: 5,
          child: Text(
            likedUsers.length.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AnimatedPositioned(
          left: 0,
          top: animateP1 ? -5 : 5, 
          duration: animationDuration,
          child: AnimatedOpacity(
            opacity: animateP1 ? 1 : 0,  
            duration: animationDuration, 
            child: const Icon(Icons.plus_one, color: Colors.green, size: 30,),
          ),
        ),
        AnimatedPositioned(
          right: 0,
          top: animateMinus ? 0 : -10,
          duration: animationDuration,
          child: 
          AnimatedOpacity(
            opacity: animateMinus ? 1 : 0,  
            duration: animationDuration, 
            child: 
            const Icon(Icons.minimize, color: Colors.black, size: 30,),
          ),
        )
      ],
    );
  }
}

