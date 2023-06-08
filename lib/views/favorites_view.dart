import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marvelapp/constants/routes.dart';
import 'package:marvelapp/models/characters_model.dart';
import 'package:marvelapp/services/api_services.dart';
import 'package:marvelapp/services/auth/auth_service.dart';
import 'package:marvelapp/views/character_card_view.dart';
import 'package:marvelapp/views/detail_view.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late Future<Character> futureCharacter;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    futureCharacter = ApiService().fetchCharacter();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.black,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('favorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final favorites = snapshot.data!.docs;

            if (favorites.isEmpty) {
              return const Center(
                child: Text(
                  'No favorites yet.',
                  style: TextStyle(
                      color: Colors
                          .white), // Establecer el color de texto en blanco
                ),
              );
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final characterId = favorites[index].id;

                return FutureBuilder<Character>(
                  future:
                      ApiService().fetchCharacterbyId(int.parse(characterId)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final character = snapshot.data!;
                      final results = character.data.results[0];
                      final image =
                          '${results.thumbnail.path}.${results.thumbnail.extension}';
                      final name = results.name;

                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CharacterDetailScreen(
                                    characterId: results.id),
                              ),
                            );
                          },
                          child: CharacterCard(
                            imageUrl: image,
                            characterName: name,
                          ));
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text('Error: ${snapshot.error}'),
                      );
                    }

                    return const ListTile(
                      title: CircularProgressIndicator(),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
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
