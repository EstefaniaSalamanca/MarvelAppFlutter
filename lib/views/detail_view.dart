import 'package:flutter/material.dart';
import 'package:marvelapp/models/characters_model.dart';
import 'package:marvelapp/services/api_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final user = FirebaseAuth.instance.currentUser;

class CharacterDetailScreen extends StatefulWidget {
  final int characterId;

  const CharacterDetailScreen({Key? key, required this.characterId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CharacterDetailScreenState createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  void checkFavorite() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('favorites')
        .doc(widget.characterId.toString())
        .get();

    setState(() {
      isFavorite = docSnapshot.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Character>(
      future: ApiService().fetchCharacterbyId(widget.characterId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final character = snapshot.data!;
          final results = character.data.results[0];
          final image =
              '${results.thumbnail.path}.${results.thumbnail.extension}';
          final name = results.name;
          final description = results.description;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Character Details'),
              backgroundColor: Colors.redAccent[700],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite;
                            if (isFavorite) {
                              // Guardar el elemento como favorito
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid)
                                  .collection('favorites')
                                  .doc(widget.characterId.toString())
                                  .set({});
                            } else {
                              // Eliminar el elemento de favoritos
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid)
                                  .collection('favorites')
                                  .doc(widget.characterId.toString())
                                  .delete();
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.favorite,
                            size: 30,
                            color: isFavorite ? Colors.orange : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Character Details'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Character Details'),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
