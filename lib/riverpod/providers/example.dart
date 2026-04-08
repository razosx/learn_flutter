// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:dio/dio.dart';

// void main() {
//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: HomeView());
//   }
// }

// final dio = Dio();

// Future<Joke> fetchRandomJoke() async {
//   // Fetching a random joke from a public API
//   final response = await dio.get<Map<String, Object?>>(
//     'https://official-joke-api.appspot.com/random_joke',
//   );

//   return Joke.fromJson(response.data!);
// }

// final randomJokeProvider = FutureProvider<Joke>((ref) async {
//   // Using the fetchRandomJoke function to get a random joke
//   return fetchRandomJoke();
// });

// class Joke
//   Joke({
//     required this.type,
//     required this.setup,
//     required this.punchline,
//     required this.id,
//   });

//   factory Joke.fromJson(Map<String, Object?> json) {
//     return Joke(
//       type: json['type']! as String,
//       setup: json['setup']! as String,
//       punchline: json['punchline']! as String,
//       id: json['id']! as int,
//     );
//   }

//   final String type;
//   final String setup;
//   final String punchline;
//   final int id;
// }

// class HomeView extends StatelessWidget {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Random Joke Generator')),
//       body: SizedBox.expand(
//         child: Consumer(
//           builder: (context, ref, _) {
//             final randomJoke = ref.watch(randomJokeProvider);
//             return Stack(
//               alignment: Alignment.center,
//               children: [
//                 if (randomJoke.isRefreshing)
//                   const Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     child: LinearProgressIndicator(),
//                   ),

//                 switch (randomJoke) {
//                   AsyncValue(:final value?) => SelectableText(
//                     '${value.setup}\n\n${value.punchline}',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                   AsyncValue(error: != null) => const Text(
//                     'Error fetching joke',
//                   ),
//                   AsyncValue() => const CircularProgressIndicator(),
//                 },

//                 Positioned(
//                   bottom: 20,
//                   child: ElevatedButton(
//                     onPressed: () => ref.invalidate(randomJokeProvider),
//                     child: const Text('Get another joke'),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
