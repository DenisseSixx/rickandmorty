import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';
import 'package:rickandmorty/services/auth_services.dart';

class FavoriteCharactersScreen extends StatefulWidget {
  @override
  _FavoriteCharactersScreenState createState() => _FavoriteCharactersScreenState();
}

class _FavoriteCharactersScreenState extends State<FavoriteCharactersScreen> {
  List<Character> favoriteCharacters = [];
  bool loadedOnce = false; // Nueva bandera

  @override
  void initState() {
    super.initState();
    // Solo carga los personajes la primera vez
    if (!loadedOnce) {
      loadFavoriteCharacters();
      loadedOnce = true; // Establece la bandera después de cargar los personajes
    }
  }

  Future<void> loadFavoriteCharacters() async {
    final userId = await Provider.of<AuthService>(context, listen: false).getUserId();

    if (userId != null) {
      // Limpiar la lista antes de cargar los personajes favoritos
      favoriteCharacters.clear();

      List<Map<String, dynamic>> personajesFavoritos =
          await Provider.of<AuthService>(context, listen: false).obtenerPersonajesFavoritos(userId);

      await Provider.of<RickProvider>(context, listen: false).getCharacters2(1); // Ajusta según tus necesidades

      List<int> characterIdsFavoritos = personajesFavoritos.map((map) => map['characterId'] as int).toList();

      List<Character> personajesFavoritosCargados =
          Provider.of<RickProvider>(context, listen: false)
              .characters
              .where((character) => characterIdsFavoritos.contains(character.id))
              .toList();

      setState(() {
        favoriteCharacters = personajesFavoritosCargados;
      });
    } else {
      // Manejar el caso en que el userId sea nulo
      print('Error: El ID del usuario es nulo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes Favoritos'),
      ),
      body: favoriteCharacters.isNotEmpty
          ? ListView.builder(
              itemCount: favoriteCharacters.length,
              itemBuilder: (context, index) {
                final personaje = favoriteCharacters[index];
                return ListTile(
                  title: Text(personaje.name ?? 'Nombre desconocido'),
                  subtitle: Text('ID: ${personaje.id}'),
                  leading: Container(
                    width: 50,
                    height: 50,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(personaje.image ?? ''),
                    ),
                  ),
                  // Nueva adición: Agregar onTap para la navegación
                  onTap: () {
                    Navigator.pushNamed(context, 'personaje', arguments: personaje);
                  },
                  // Puedes mostrar más detalles del personaje si es necesario
                );
              },
            )
          : Center(
              child: Text('No hay personajes favoritos.'),
            ),
    );
  }
}
