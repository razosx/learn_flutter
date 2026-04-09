import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/cubit/cubits/user/user_cubit.dart';
import 'package:store/cubit/cubits/user/user_state.dart';
import 'package:store/cubit/screens/widgets/random_user_card_widget.dart';

class FriendsListWidgetCubit extends StatelessWidget {
  const FriendsListWidgetCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserCubitState>(
      builder: (context, state) {
        Widget content;
        if (state is UserCubitLoading || state is UserCubitInitial) {
          content = const Center(child: CircularProgressIndicator());
        } else if (state is UserCubitError) {
          content = const Center(child: Text('Error loading friends'));
        } else if (state is UserCubitLoaded) {
          content = GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            padding: const EdgeInsets.all(8),
            children: List.generate(state.users.length, (index) {
              return RandomUserCardWidgetCubit(
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
