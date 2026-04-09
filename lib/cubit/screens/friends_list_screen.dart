import 'package:flutter/material.dart';
import 'package:store/cubit/screens/widgets/friends_list_widget.dart';
import 'package:store/cubit/screens/widgets/liked_users_widget.dart';

class FriendsListCubitScreen extends StatelessWidget {
  const FriendsListCubitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
        actions: [
          const LikedUsersWidgetCubit(),
        ],
      ),
      body: const Column(
        children: [
          FriendsListWidgetCubit(),
        ],
      ),
    );
  }
}
