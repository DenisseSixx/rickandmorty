/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/locations_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';

class LocationScreen extends StatelessWidget {
  final List<Locations> L;
  const LocationScreen({super.key, required this.L});
 
  @override
  State<LocationScreen> createState() => _LocationState();
}
class _LocationState extends State<LocationScreen> {
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  @override
  void initState() {
    super.initState();
    final rickProvider = Provider.of<RickProvider>(context, listen: false);
    rickProvider.getCharacters(page);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await rickProvider.getCharacters(page);
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
                showSearch(context: context, delegate: SearchCharacter());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: rickProvider.characters.isNotEmpty
            ? CharacterList(
                rickProvider: rickProvider,
                isLoading: isLoading,
                scrollController: scrollController, p: [],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class CharacterList extends StatelessWidget {
  final List<Character> p;

  const CharacterList({
    Key? key,
    required this.rickProvider,
    required this.scrollController,
    required this.isLoading,
    required this.p,
  });

  final RickProvider rickProvider;
  final ScrollController scrollController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
      itemCount: isLoading
          ? rickProvider.characters.length + 2
          : rickProvider.characters.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index < rickProvider.characters.length) {
          final character = rickProvider.characters[index];
          return GestureDetector(
            onTap: () {
                 Navigator.pushNamed(context, 'personaje', arguments: character);
            },
            child: Card(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                leading: Hero(
                 
                  tag: character.id!,
                   child: Container(
                    width: 100,
                    height: 700,
                  child: FadeInImage(
                    placeholder:  AssetImage('assets/no-image.jpg'),
                    image: NetworkImage(character.image),
                    fit: BoxFit.cover,
                  ),
                ),
                ),
                title: Text(
                  character.name!,
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
      ),
    );
  }
}
}*/