import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/episode_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';
import 'package:rickandmorty/screens/episode_details.dart';
import 'package:rickandmorty/widgets/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/episode_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';
import 'package:rickandmorty/screens/episode_details.dart';
import 'package:rickandmorty/widgets/search_delegate.dart';

class EpisodeListScreen extends StatefulWidget {
  final List<Episode> epi;

  const EpisodeListScreen({Key? key, required this.epi}) : super(key: key);

  @override
  State<EpisodeListScreen> createState() => _EpisodeState();
}

class _EpisodeState extends State<EpisodeListScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    final rickProvider = Provider.of<RickProvider>(context, listen: false);
    rickProvider.getEpisode(page);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await rickProvider.getEpisode(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rickProvider = Provider.of<RickProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rick And Morty',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchEpisode());
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: rickProvider.episodes.isNotEmpty
          ? EpisodeList(
              rickProvider: rickProvider,
              scrollController: scrollController,
              isLoading: isLoading,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class EpisodeList extends StatelessWidget {
  final RickProvider rickProvider;
  final ScrollController scrollController;
  final bool isLoading;

  const EpisodeList({
    required this.rickProvider,
    required this.scrollController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rickProvider.episodes.length + (isLoading ? 1 : 0),
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index < rickProvider.episodes.length) {
          final episode = rickProvider.episodes[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'epidetail', arguments: episode);
            },
            child: Card(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                 leading: Text(episode.episode!),
                title: Text(
                  episode.name,
                  style: const TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
