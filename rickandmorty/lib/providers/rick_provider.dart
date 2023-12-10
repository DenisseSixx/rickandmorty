import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:http/http.dart' as http;
import 'package:rickandmorty/models/episode_response.dart';
import 'package:rickandmorty/services/auth_services.dart';
import 'package:collection/collection.dart';

class RickProvider extends ChangeNotifier {


  
  String url = 'rickandmortyapi.com';
  
  List<Character> characters = [];
  List<Episode> episodes = [];
  List<Location> locations = [];

 getCharacters(int page) async {
  characters.clear();
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
   getEpisode(int epi) async {
    var result = await http.get(Uri.https(url, "api/episode", {
      'page': epi.toString(),
    }));
    final response = EpisodeResponse.fromRawJson(result.body);
    episodes.addAll(response.results);
    notifyListeners();
  }
    Future<List<Episode>> getEpiso(Episode episode) async {
    episodes = [];
    for (var i = 0; i < episode.episode!.length; i++) {
      final result = await http.get(Uri.parse(episode.episode![i]));
      final response = Episode.fromRawJson(result.body);
      episodes.add(response);
      notifyListeners();
    }
    return episodes;
  }
 Future<List<Episode>> searchEpisodesByName(String name) async {
    // Filtrar los episodios cuyo nombre contiene la consulta (ignorando mayúsculas y minúsculas)
    final filteredEpisodes = episodes
        .where((episode) =>
            episode.name?.toLowerCase().contains(name.toLowerCase()) ?? false)
        .toList();

    return Future.value(filteredEpisodes);
  }
 Future<List<Character>> loadCharacters() async {
    await getCharacters(1); // Supongamos que page es 1, puedes ajustar esto según tus necesidades
    return characters;
  }



}

