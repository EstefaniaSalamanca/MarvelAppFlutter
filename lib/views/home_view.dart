import 'package:flutter/material.dart';
import 'package:marvelapp/enums/menu_action.dart';
import 'package:marvelapp/constants/routes.dart';
import 'package:marvelapp/models/characters_model.dart';
import 'package:marvelapp/services/api_services.dart';
import 'package:marvelapp/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Character> fetchCharacter() async {
  final response = await http.get(Uri.parse(
      'http://gateway.marvel.com/v1/public/characters?ts=1&apikey=4dc1b141446d7991b4e54a55fc103bf7&hash=710b5b7151872e980d79f983bcb6331d'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Character.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load character');
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<Character> futureCharacter;

  @override
  void initState() {
    super.initState();
    futureCharacter = fetchCharacter();
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
                    // Lógica para cerrar sesión
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
      body: FutureBuilder<Character>(
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

                return ListTile(
                  title: Column(
                    children: [
                      Container(
                        width:
                            double.infinity, // Ocupa todo el ancho disponible
                        child: Image.network(
                          image,
                          fit: BoxFit.contain, // La imagen no se estira
                        ),
                      ),
                      SizedBox(
                          height: 8), // Espacio entre la imagen y el nombre
                      Text(
                        name,
                        textAlign: TextAlign.center, // Centra el texto
                      ),
                    ],
                  ),
                );
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
        currentIndex: 0,
        selectedItemColor: Colors.red[700],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      // Implementa la lógica para cambiar de índice
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
              // Redirige a la vista de inicio de sesión
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
