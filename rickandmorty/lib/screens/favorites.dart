import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/services/auth_services.dart'; // Importa tu servicio aquí

class FavoriteCharactersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes Favoritos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
                  title: Text(personaje['name']),
                  subtitle: Text('ID: ${personaje['id']}'),
                  // Puedes mostrar más detalles del personaje si es necesario
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> obtenerPersonajesFavoritos(BuildContext context) async {
    final userId = await Provider.of<AuthService>(context, listen: false).getUserId();
    if (userId != null) {
      return await Provider.of<AuthService>(context, listen: false).obtenerPersonajesFavoritos(userId);
    } else {
      return [];
    }
  }
}
