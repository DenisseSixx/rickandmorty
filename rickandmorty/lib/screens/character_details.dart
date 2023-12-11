import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';
import 'package:rickandmorty/services/auth_services.dart';

class CharacterScreen extends StatefulWidget {
  final List<Character> detalles;

  const CharacterScreen({Key? key, required this.detalles, required List Detalles}) : super(key: key);

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
 
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context, listen: false);

  final Character character = ModalRoute.of(context)?.settings.arguments as Character;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(character.name),
        actions: [
          // Botón en el AppBar para agregar o eliminar de favoritos
          IconButton(
            onPressed: () {
              toggleFavorite();
            },
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.35,
              width: double.infinity,
              child: Hero(
                tag: character.id!,
                child: Image.network(
                  character.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: size.height * 0.14,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cardData("Status:", character.status),
                  cardData("Specie:", character.species),
                  cardData("Origin:", character.origin.name),
                  cardData("Gender:", character.gender),
                ],
              ),
            ),
            const Text(
              'Episodes',
              style: TextStyle(fontSize: 17),
            ),
            EpisodeList(size: size, character: character),
          ],
        ),
      ),
    );
  }

  Widget cardData(String text1, String text2) {
    return Expanded(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(text1),
            Text(
              text2,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }

  

 void toggleFavorite() async {
  setState(() {
    isFavorite = !isFavorite;
  });

  final authService = Provider.of<AuthService>(context, listen: false);
  final dynamic arguments = ModalRoute.of(context)!.settings.arguments;

  if (arguments is Character) {
    final Character character = arguments;

    if (character.id != null) {
      final int characterId = character.id!;
      final String? userEmail = await authService.getUserId();

      if (userEmail != null) {
        try {
          if (isFavorite) {
            print('Agregando a favoritos');
            await authService.agregarPersonajeFavorito(userEmail, characterId);
          } else {
            print('Quitando de favoritos');
            await authService.eliminarPersonajeFavorito(userEmail, characterId);

            // Si se eliminó con éxito de la base de datos, también quítalo de la lista local
            setState(() {
              isFavorite = false;
            });
          }
        } catch (e) {
          print('Error al manejar la lista de favoritos: $e');
        }
      } else {
        print('El email del usuario es nulo');
      }
    } else {
      print('El ID del personaje es nulo');
    }
  } else {
    print('Los argumentos no son de tipo Character');
  }
}

}



class EpisodeList extends StatefulWidget {
  const EpisodeList({Key? key, required this.size, required this.character}) : super(key: key);

  final Size size;
  final Character character;

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  void initState() {
    final apiProvider = Provider.of<RickProvider>(context, listen: false);
    apiProvider.getEpisodes(widget.character);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<RickProvider>(context);
    return SizedBox(
      height: widget.size.height * 0.35,
      child: ListView.builder(
        itemCount: apiProvider.episodes.length,
        itemBuilder: (context, index) {
          final episode = apiProvider.episodes[index];
          return ListTile(
            leading: Text(episode.episode!),
            title: Text(episode.name!),
            trailing: Text(episode.airDate!),
          );
        },
      ),
    );
  }
}
