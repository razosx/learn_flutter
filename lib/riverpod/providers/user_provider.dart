import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store/models/random_user.dart';
import 'package:store/networking/dio_util.dart';
import 'package:store/riverpod/utils/enums.dart';

part 'user_provider.g.dart';

@riverpod
Future<List<RandomUser>> randomUserList(ref) async {
  // Fetching a list of random users using
  return await fetchRandomUsers(10);
}


@Riverpod(keepAlive: true)
class RandomUserState extends _$RandomUserState {

  @override
   LikeState build(int index) {
    return LikeState.neutral;
  }

  void changeLikeState(LikeState newState) {
    state = newState;
  }
}