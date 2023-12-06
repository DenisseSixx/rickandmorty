import 'package:flutter/material.dart';
import 'package:rickandmorty/models/episode_response.dart';

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
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.greenAccent.withOpacity(0.1),
              child: Column(
                children: [
                  CardData("Air Date", episode.airDate),
                  SizedBox(height: 16),
                  CardData("Episode", episode.episode),
                  SizedBox(height: 16),
                  CardData("Name", episode.name),
                ],
              ),
            ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text2,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
