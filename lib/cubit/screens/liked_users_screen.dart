import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/cubit/cubits/liked_users/liked_users_cubit.dart';
import 'package:store/cubit/cubits/liked_users/liked_users_state.dart';

class LikedUsersCubitScreen extends StatelessWidget {
  const LikedUsersCubitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liked Users')),
      body: BlocBuilder<LikedUsersCubit, LikedUsersCubitState>(
        builder: (context, state) {
          if (state.likedUsers.isEmpty) {
            return const Center(
              child: Text('List of liked users will be displayed here.'),
            );
          }
          return ListView.builder(
            itemCount: state.likedUsers.length,
            itemBuilder: (context, index) {
              final user = state.likedUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.picture.thumbnail),
                ),
                title: Text(user.name.first),
                subtitle: Text(user.email),
              );
            },
          );
        },
      ),
    );
  }
}
