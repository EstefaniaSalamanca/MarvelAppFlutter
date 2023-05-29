import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:marvelapp/models/characters_model.dart';
import 'package:marvelapp/constants/api.dart';

class ApiService {
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
}
