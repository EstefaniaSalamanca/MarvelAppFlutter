import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marvelapp/models/characters_model.dart';

class ApiService {
  Future<Character> fetchCharacter() async {
    final response = await http.get(Uri.parse(
        'http://gateway.marvel.com/v1/public/characters?limit=99&ts=1&apikey=4dc1b141446d7991b4e54a55fc103bf7&hash=710b5b7151872e980d79f983bcb6331d'));

    if (response.statusCode == 200) {
      return Character.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load character');
    }
  }

  Future<Character> fetchCharacterbyId(int characterId) async {
    final response = await http.get(Uri.parse(
        'https://gateway.marvel.com:443/v1/public/characters/$characterId?ts=1&apikey=4dc1b141446d7991b4e54a55fc103bf7&hash=710b5b7151872e980d79f983bcb6331d'));

    if (response.statusCode == 200) {
      return Character.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load character');
    }
  }

  Future<Character> fetchCharacterbyName(String query) async {
    final response = await http.get(Uri.parse(
        'https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=$query&ts=1&apikey=4dc1b141446d7991b4e54a55fc103bf7&hash=710b5b7151872e980d79f983bcb6331d'));

    if (response.statusCode == 200) {
      return Character.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load character');
    }
  }
}
