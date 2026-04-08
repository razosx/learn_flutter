import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/bloc/blocs/liked_users/liked_users_bloc.dart';
import 'package:store/bloc/blocs/user/user_bloc.dart';
import 'package:store/bloc/blocs/user/user_event.dart';
import 'package:store/bloc/repositories/user_repository.dart';
import 'package:store/bloc/screens/friends_list_screen.dart';
import 'package:store/riverpod/screens/friends_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MyHomePage(title: 'Shopping App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const FriendsList()
                  )
                );
              }, 
              child: const Text('Riverpod')
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const BlocStorePage()
                  )
                );
              }, 
              child: const Text('Bloc')
            ),
          ],
        ),
      ),      
    );
  }
}

class RiverpodStorePage extends StatefulWidget {
  const RiverpodStorePage({super.key});

  @override
  State<RiverpodStorePage> createState() => _RiverpodStorePageState();
}

class _RiverpodStorePageState extends State<RiverpodStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Store'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: const Icon(Icons.shopping_cart)
          )
        ],
      ),
      body: const Center(
        child: Text('Riverpod Store Page'),
      ),
    );
  }
}

class BlocStorePage extends StatelessWidget {
  const BlocStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(repository: const RandomUserRepository())
            ..add(const FetchUsersEvent()),
        ),
        BlocProvider<LikedUsersBloc>(
          create: (_) => LikedUsersBloc(),
        ),
      ],
      child: const FriendsListBlocScreen(),
    );
  }
}