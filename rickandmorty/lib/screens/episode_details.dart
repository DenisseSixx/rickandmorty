import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/episode_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';

class EpisodeScreen extends StatelessWidget {
  final List<Episode> Det;

  const EpisodeScreen({Key? key, required this.Det}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Episode episode = ModalRoute.of(context)?.settings.arguments as Episode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(episode.name),
        backgroundColor: Colors.indigo, // Puedes cambiar el color del AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.indigoAccent.withOpacity(0.1), // Fondo ligeramente azul
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CardData("Air date:", episode.airDate),
                  ),
                  Expanded(
                    child: CardData("Episode:", episode.episode),
                  ),
                  Expanded(
                    child: CardData("Name:", episode.name),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.indigoAccent.withOpacity(0.1), // Fondo ligeramente azul
              child: Text(
                'Related Episodes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            EpisodeList(size: size, episode: episode),
          ],
        ),
      ),
    );
  }
}

class CardData extends StatelessWidget {
  final String text1;
  final String text2;

  const CardData(this.text1, this.text2, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo, // Puedes cambiar el color del texto
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text2,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.black87, // Puedes cambiar el color del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EpisodeList extends StatefulWidget {
  const EpisodeList({Key? key, required this.size, required this.episode})
      : super(key: key);

  final Size size;
  final Episode episode;

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  void initState() {
    final apiProvider = Provider.of<RickProvider>(context, listen: false);
    apiProvider.getEpiso(widget.episode);
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
            tileColor: index % 2 == 0 ? Colors.green.withOpacity(0.1) : null, // Alternar colores de fondo
            leading: Text(episode.episode!),
            title: Text(episode.name!),
            trailing: Text(episode.airDate!),
          );
        },
      ),
    );
  }
}
