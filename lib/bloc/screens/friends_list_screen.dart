import 'package:flutter/material.dart';
import 'package:store/bloc/screens/widgets/friends_list_widget.dart';
import 'package:store/bloc/screens/widgets/liked_users_widget.dart';

class FriendsListBlocScreen extends StatelessWidget {
  const FriendsListBlocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
        actions: [
          const LikedUsersWidgetBloc(),
        ],
      ),
      body: const Column(
        children: [
          FriendsListWidgetBloc(),
        ],
      ),
    );
  }
}
