import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';

class CharacterScreen extends StatelessWidget {

  final List<Character> Detalles;
  
  const CharacterScreen({super.key,  required this.Detalles});

  @override
  Widget build(BuildContext context) {
    final Character character = ModalRoute.of(context)?.settings.arguments as Character;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(character.name),
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
                 // cardData("Origin:", character.gender),
                  cardData("Gender:", character.gender),
                ],
              ),
            ),
            const Text(
              'Episodes',
              style: TextStyle(fontSize: 17),
            ),
            EpisodeList(size: size, character: character)
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
  const EpisodeList({super.key, required this.size, required this.character});

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