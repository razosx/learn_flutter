import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_bloc.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_event.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_state.dart';
import 'package:store/bloc/screens/liked_users_screen.dart';

const Duration _animationDuration = Duration(milliseconds: 500);

class LikedUsersWidgetBloc extends StatefulWidget {
  const LikedUsersWidgetBloc({super.key});

  @override
  State<LikedUsersWidgetBloc> createState() => _LikedUsersWidgetBlocState();
}

class _LikedUsersWidgetBlocState extends State<LikedUsersWidgetBloc> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LikedUsersBloc, LikedUsersState>(
      listenWhen: (prev, curr) =>
          curr.animateP1 != prev.animateP1 ||
          curr.animateMinus != prev.animateMinus,
      listener: (context, state) {
        if (state.animateP1 || state.animateMinus) {
          Future.delayed(_animationDuration, () {
            if (context.mounted) {
              context
                  .read<LikedUsersBloc>()
                  .add(const ResetAnimationEvent());
            }
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<LikedUsersBloc>(),
                      child: const LikedUsersBlocScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.favorite, color: Colors.red),
            ),
            Positioned(
              left: 5,
              top: 5,
              child: Text(
                state.likedUsers.length.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AnimatedPositioned(
              left: 0,
              top: state.animateP1 ? -5 : 5,
              duration: _animationDuration,
              child: AnimatedOpacity(
                opacity: state.animateP1 ? 1 : 0,
                duration: _animationDuration,
                child: const Icon(Icons.plus_one, color: Colors.green, size: 30),
              ),
            ),
            AnimatedPositioned(
              right: 0,
              top: state.animateMinus ? 0 : -10,
              duration: _animationDuration,
              child: AnimatedOpacity(
                opacity: state.animateMinus ? 1 : 0,
                duration: _animationDuration,
                child: const Icon(Icons.minimize, color: Colors.black, size: 30),
              ),
            ),
          ],
        );
      },
    );
  }
}
