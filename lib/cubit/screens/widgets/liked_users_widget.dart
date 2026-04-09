import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/cubit/cubits/liked_users/liked_users_cubit.dart';
import 'package:store/cubit/cubits/liked_users/liked_users_state.dart';
import 'package:store/cubit/screens/liked_users_screen.dart';

const Duration _animationDuration = Duration(milliseconds: 500);

class LikedUsersWidgetCubit extends StatefulWidget {
  const LikedUsersWidgetCubit({super.key});

  @override
  State<LikedUsersWidgetCubit> createState() => _LikedUsersWidgetCubitState();
}

class _LikedUsersWidgetCubitState extends State<LikedUsersWidgetCubit> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LikedUsersCubit, LikedUsersCubitState>(
      // Solo escucha cambios en las flags de animación para arrancar el timer.
      listenWhen: (prev, curr) =>
          curr.animateP1 != prev.animateP1 ||
          curr.animateMinus != prev.animateMinus,
      listener: (context, state) {
        if (state.animateP1 || state.animateMinus) {
          // Cubit: llama resetAnimation() directamente tras 500ms.
          // El Cubit no maneja timers internamente; el widget es responsable.
          Future.delayed(_animationDuration, () {
            if (context.mounted) {
              context.read<LikedUsersCubit>().resetAnimation();
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
                      // Pasa el Cubit existente a la nueva pantalla sin recrearlo.
                      value: context.read<LikedUsersCubit>(),
                      child: const LikedUsersCubitScreen(),
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
                child:
                    const Icon(Icons.minimize, color: Colors.black, size: 30),
              ),
            ),
          ],
        );
      },
    );
  }
}
