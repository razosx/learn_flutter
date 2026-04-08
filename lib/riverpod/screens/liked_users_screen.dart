import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/riverpod/providers/liked_users_provider.dart';

class LikedUsersScreen extends ConsumerWidget {
  const LikedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedUsers = ref.watch(likedUsersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Liked Users')),
      body: 
      likedUsers.isNotEmpty ? 
        ListView.builder(
          itemCount: likedUsers.length,
          itemBuilder: (context, index) {
            final user = likedUsers.elementAt(index);
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.picture.thumbnail),
              ),
              title: Text(user.name.first),
              subtitle: Text(user.email),
            );
          },
        )
      :
      const Center(
        child: Text('List of liked users will be displayed here.'),
      ),
    );
  }
}
