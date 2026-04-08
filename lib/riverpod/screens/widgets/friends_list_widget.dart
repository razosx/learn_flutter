import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/riverpod/providers/user_provider.dart';
import 'package:store/riverpod/screens/widgets/random_user_card_widget.dart';

class FriendsListWidget extends ConsumerWidget {
  const FriendsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsyncValue = ref.watch(randomUserListProvider);
    Widget content;
    switch (friendsAsyncValue) {
      case AsyncLoading():
        content = const Center(child: CircularProgressIndicator());
      case AsyncError():
        content = const Center(child: Text('Ergo run .ror loading friends'));
      case AsyncData():
        final friends = friendsAsyncValue.value;
        content = GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          padding: const EdgeInsets.all(8),
          children: List.generate(friends.length, (index) {
            final randomUser = friends[index];
            return RandomUserCardWidget(randomUser: randomUser, index: index, key: UniqueKey(),);
          }),
        );
    }

    return Expanded(
      child: content
    );
  }
}
