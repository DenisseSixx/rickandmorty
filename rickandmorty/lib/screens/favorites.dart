import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:rickandmorty/services/auth_services.dart';
import 'package:rickandmorty/providers/rick_provider.dart';

class FavoriteCharactersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personajes Favoritos'),
      ),
      body: FavoriteCharactersList(),
    );
  }
}

class FavoriteCharactersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: authService.getUserId().then((userId) => authService.obtenerPersonajesFavoritos(userId!)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No hay personajes favoritos.');
        } else {
          final favoriteCharacters = snapshot.data!;
          return ListView.builder(
            itemCount: favoriteCharacters.length,
            itemBuilder: (context, index) {
              final character = favoriteCharacters[index];
              return ListTile(
                title: Text(character['characterName']),
                subtitle: Text('ID: ${character['characterId']}'),
              );
            },
          );
        }
      },
    );
  }
}
