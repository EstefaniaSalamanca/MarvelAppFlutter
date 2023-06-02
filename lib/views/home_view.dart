import 'package:flutter/material.dart';
import 'package:marvelapp/constants/routes.dart';
import 'package:marvelapp/models/characters_model.dart';
import 'package:marvelapp/services/api_services.dart';
import 'package:marvelapp/services/auth/auth_service.dart';
import 'package:marvelapp/views/character_card_view.dart';

import 'detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<Character> futureCharacter;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureCharacter = ApiService().fetchCharacter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.redAccent[700],
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          FutureBuilder<Character>(
            future: futureCharacter,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final character = snapshot.data!;
                final results = character.data.results;
                // Si el Future tiene datos, muestra el ListView con la respuesta
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    final image =
                        '${result.thumbnail.path}.${result.thumbnail.extension}';
                    final name = result.name;

                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CharacterDetailScreen(characterId: result.id),
                            ),
                          );
                        },
                        child: CharacterCard(
                          imageUrl: image,
                          characterName: name,
                        ));
                  },
                );
              } else if (snapshot.hasError) {
                // Si el Future tiene un error, muestra un mensaje de error
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              // Mientras se está cargando el Future, muestra un indicador de progreso
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[700],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          _selectedIndex = 0;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home/',
            (route) => false,
          );
          break;
        case 1:
          _selectedIndex = 1;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/search/',
            (route) => false,
          );
          break;
        case 2:
          _selectedIndex = 2;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/favorites/',
            (route) => false,
          );
          break;
      }
    });
  }
}

enum MenuAction { logout }

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login/',
                (route) => false,
              );
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
