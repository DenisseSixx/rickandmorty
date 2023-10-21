import 'package:flutter/material.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:http/http.dart' as http;
import 'package:rickandmorty/models/episode_response.dart';

class RickProvider extends ChangeNotifier {
  String url = 'rickandmortyapi.com';
  
  List<Character> characters = [];
  List<Episode> episodes = [];

 getCharacters(int page) async {
    var result = await http.get(Uri.https(url, "api/character", {
      'page': page.toString(),
    }));
    final response = CharacterResponse.fromRawJson(result.body);
    characters.addAll(response.results);
    notifyListeners();
  }

  Future<List<Character>> getCharacter(String name) async {
    var result =
        await http.get(Uri.https(url, 'api/character/', {'name': name}));
    final response = CharacterResponse.fromRawJson(result.body);
    return response.results;
  }

  Future<List<Episode>> getEpisodes(Character character) async {
    episodes = [];
    for (var i = 0; i < character.episode!.length; i++) {
      final result = await http.get(Uri.parse(character.episode![i]));
      final response = Episode.fromRawJson(result.body);
      episodes.add(response);
      notifyListeners();
    }
    return episodes;
  }
}