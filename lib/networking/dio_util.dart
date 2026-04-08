
import 'package:dio/dio.dart';
import 'package:store/models/random_user.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://randomuser.me/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ),
);

Future<List<RandomUser>> fetchRandomUsers(int results) async {
  try {
    final response = await dio.get('?results=$results');
    return (response.data['results'] as List)
        .map((e) => RandomUser.fromJson(e))
        .toList();
  } catch (e) {
    throw Exception('Failed to load random user: $e');
  }
}

