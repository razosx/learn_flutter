import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/bloc/blocs/user/user_bloc.dart';
import 'package:store/bloc/blocs/user/user_state.dart';
import 'package:store/bloc/screens/widgets/random_user_card_widget.dart';

class FriendsListWidgetBloc extends StatelessWidget {
  const FriendsListWidgetBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        Widget content;
        if (state is UserLoading || state is UserInitial) {
          content = const Center(child: CircularProgressIndicator());
        } else if (state is UserError) {
          content = const Center(child: Text('Error loading friends'));
        } else if (state is UserLoaded) {
          content = GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            padding: const EdgeInsets.all(8),
            children: List.generate(state.users.length, (index) {
              return RandomUserCardWidgetBloc(
                key: UniqueKey(),
                randomUser: state.users[index],
                index: index,
              );
            }),
          );
        } else {
          content = const SizedBox.shrink();
        }

        return Expanded(child: content);
      },
    );
  }
}
