import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_bloc.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_state.dart';

class LikedUsersBlocScreen extends StatelessWidget {
  const LikedUsersBlocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liked Users')),
      body: BlocBuilder<LikedUsersBloc, LikedUsersState>(
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
