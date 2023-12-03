import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:rickandmorty/models/episode_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';

class SearchCharacter extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final characterProvider = Provider.of<RickProvider>(context);

    Widget circleLoading() {
      return const Center(
        child: CircleAvatar(
          radius: 100,
          backgroundImage: AssetImage('assets/rmorty.gif'),
        ),
      );
    }

    if (query.isEmpty) {
      return circleLoading();
    }

    return FutureBuilder(
      future: characterProvider.getCharacter(query),
      builder: (context, AsyncSnapshot<List<Character>> snapshot) {
        if (!snapshot.hasData) {
          return circleLoading();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final character = snapshot.data![index];
            return ListTile(
              onTap: () {
                 Navigator.pushNamed(context, 'personaje', arguments: character);
              },
              title: Text(character.name!),
              leading: Hero(
                  tag: character.id!,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(character.image!),
                  )),
            );
          },
        );
      },
    );
  }
}
class SearchEpisode extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final episodeProvider = Provider.of<RickProvider>(context);

    Widget circleLoading() {
      return const Center(
        child: CircleAvatar(
          radius: 100,
          backgroundImage: AssetImage('assets/rmorty.gif'),
        ),
      );
    }

    if (query.isEmpty) {
      return circleLoading();
    }

    return FutureBuilder(
  future: episodeProvider.searchEpisodesByName(query),
  builder: (context, AsyncSnapshot<List<Episode>> snapshot) {
    if (!snapshot.hasData) {
      return circleLoading();
    }
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final episode = snapshot.data![index];
        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, 'epidetail', arguments: episode);
          },
          title: Text(episode.name ?? 'Sin nombre'),
        );
      },
    );
  },
);
  }
}
