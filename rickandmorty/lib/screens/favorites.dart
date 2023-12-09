import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character.dart'; // Importa tu modelo de personaje
import 'package:rickandmorty/services/auth_services.dart'; // Importa tu servicio aquí

class FavoriteCharactersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes Favoritos'),
      ),
      body: FutureBuilder<List<Character>>(
        future: obtenerPersonajesFavoritos(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay personajes favoritos.'),
            );
          } else {
            // Mostrar la lista de personajes favoritos
            final personajesFavoritos = snapshot.data!;
            return ListView.builder(
              itemCount: personajesFavoritos.length,
              itemBuilder: (context, index) {
                final personaje = personajesFavoritos[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(personaje.fullPosterImg ?? ''),
                  ),
                  title: Text(personaje.name ?? 'Nombre desconocido'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${personaje.id}'),
                      Text('Status: ${personaje.status ?? ''}'),
                      Text('Species: ${personaje.species ?? ''}'),
                      // Agrega más detalles según sea necesario
                    ],
                  ),
                  // Puedes mostrar más detalles del personaje si es necesario
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Character>> obtenerPersonajesFavoritos(BuildContext context) async {
    final userId = await Provider.of<AuthService>(context, listen: false).getUserId();
    if (userId != null) {
      // Obtener la lista de personajes favoritos por ID del usuario
      final List<Map<String, dynamic>> personajesData =
          await Provider.of<AuthService>(context, listen: false).obtenerPersonajesFavoritos(userId);

      // Mapear la lista de mapas a objetos Character
      final List<Character> personajes =
          personajesData.map((data) => Character.fromJson(data)).toList();

      return personajes;
    } else {
      // Muestra un mensaje de error o toma otra acción según tus necesidades
      print('Error: El ID del usuario es nulo.');
      return [];
    }
  }
}
