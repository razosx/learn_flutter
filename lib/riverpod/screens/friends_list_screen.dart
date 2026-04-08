import 'package:flutter/material.dart';
import 'package:store/riverpod/screens/widgets/friends_list_widget.dart';
import 'package:store/riverpod/screens/widgets/liked_users_widget.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
        actions: [
          LikedUsersWidget()
        ],),
      body: Column(
        children: [
          FriendsListWidget()
        ],
      ),
    );
  }
}
