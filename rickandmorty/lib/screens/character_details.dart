import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';
import 'package:rickandmorty/services/auth_services.dart';

class CharacterScreen extends StatefulWidget {
  final List<Character> Detalles;

  const CharacterScreen({Key? key, required this.Detalles}) : super(key: key);

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  late AuthService _authService;
  bool isFavorite = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false);
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    final String? userId = await _authService.getUserId();

    if (userId != null && widget.Detalles.isNotEmpty) {
      final Character character = widget.Detalles.first;

      final List<Map<String, dynamic>> favorites =
          await _authService.obtenerPersonajesFavoritos(userId);

      setState(() {
        isFavorite = favorites.any(
          (favorite) => favorite['characterId'] == character.id,
        );
      });
    }
  }

  Future<void> toggleFavorite() async {
    final String? userId = await _authService.getUserId();

    if (userId != null && widget.Detalles.isNotEmpty) {
      final Character character = widget.Detalles.first;

      if (isFavorite) {
        await _authService.eliminarPersonajeFavorito(userId, character.id!);
        setMessage('Personaje eliminado de favoritos');
      } else {
        await _authService.agregarPersonajeFavorito(userId, character.id!);
        setMessage('Personaje agregado a favoritos');
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  void setMessage(String newMessage) {
    setState(() {
      message = newMessage;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        message = '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Character character =
        ModalRoute.of(context)?.settings.arguments as Character;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(character.name),
        actions: [
          IconButton(
            onPressed: toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
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
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isFavorite ? Colors.red : Colors.green,
                  ),
                ),
              ),
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
}

class EpisodeList extends StatefulWidget {
  const EpisodeList({Key? key, required this.size, required this.character})
      : super(key: key);

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
