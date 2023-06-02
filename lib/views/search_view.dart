import 'package:flutter/material.dart';
import 'package:marvelapp/constants/routes.dart';
import 'package:marvelapp/models/characters_model.dart';
import 'package:marvelapp/services/api_services.dart';
import 'package:marvelapp/services/auth/auth_service.dart';
import 'package:marvelapp/views/character_card_view.dart';
import 'package:marvelapp/views/detail_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late Future<Character> futureCharacter;
  int _selectedIndex = 1;
  List<Result> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    futureCharacter = ApiService().fetchCharacter();
  }

  Future<Character> fetchCharacterByName(String query) async {
    return ApiService().fetchCharacterbyName(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isSearching = true;
                    });
                    fetchCharacterByName(value).then((character) {
                      setState(() {
                        searchResults = character.data.results;
                      });
                    });
                  } else {
                    setState(() {
                      isSearching = false;
                      searchResults.clear();
                    });
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: isSearching
                ? ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final result = searchResults[index];
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
                        ),
                      );
                    },
                  )
                : FutureBuilder<Character>(
                    future: futureCharacter,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        final character = snapshot.data!;
                        final results = character.data.results;

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
                                    builder: (context) => CharacterDetailScreen(
                                        characterId: result.id),
                                  ),
                                );
                              },
                              child: CharacterCard(
                                imageUrl: image,
                                characterName: name,
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
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
          break; // Agregar break después de cada caso
        case 1:
          _selectedIndex = 1;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/search/',
            (route) => false,
          );
          break; // Agregar break después de cada caso
        case 2:
          _selectedIndex = 2;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/favorites/',
            (route) => false,
          );
          break; // Agregar break después de cada caso
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
