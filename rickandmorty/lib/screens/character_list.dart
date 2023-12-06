import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';
import 'package:rickandmorty/widgets/search_delegate.dart';
import 'package:rickandmorty/services/auth_services.dart';

class CharacterListScreen extends StatefulWidget {
  final List<Character> p;
  const CharacterListScreen({super.key, required this.p});

  @override
  State<CharacterListScreen> createState() => _CharacterState();
}

class _CharacterState extends State<CharacterListScreen> {
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
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: rickProvider.characters.isNotEmpty
            ? CharacterList(
                rickProvider: rickProvider,
                isLoading: isLoading,
                scrollController: scrollController,
                p: [],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class CharacterList extends StatefulWidget {
  final List<Character> p;

  const CharacterList({
    Key? key,
    required this.rickProvider,
    required this.scrollController,
    required this.isLoading,
    required this.p,
  }) : super(key: key);

  final RickProvider rickProvider;
  final ScrollController scrollController;
  final bool isLoading;

  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  late AuthService authService;  // Agrega esta línea

  @override
  void initState() {
    super.initState();
    authService = Provider.of<AuthService>(context, listen: false);  // Inicializa authService
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: widget.isLoading
            ? widget.rickProvider.characters.length + 2
            : widget.rickProvider.characters.length,
        controller: widget.scrollController,
        itemBuilder: (context, index) {
          if (index < widget.rickProvider.characters.length) {
            final character = widget.rickProvider.characters[index];
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
                        placeholder: AssetImage('assets/no-image.jpg'),
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
                 trailing: FutureBuilder<bool>(
                   future: isFavorite(character.id!),
                   builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return CircularProgressIndicator();
                     } else if (snapshot.hasError) {
                       return Icon(Icons.favorite, color: Colors.grey);
                     } else {
                       bool isFavorite = snapshot.data ?? false;
                       return IconButton(
                         icon: Icon(Icons.favorite),
                         color: isFavorite ? Colors.red : Colors.grey,
                         onPressed: () {
                           toggleFavorite(character.id!, isFavorite);
                         },
                       );
                     }
                   },
                 ),
               ),
             )
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

  // Función para verificar si el personaje es favorito
  Future<bool> isFavorite(int characterId) async {
    final List<int> favorites = await authService.getFavorites();
    return favorites.contains(characterId);
  }

  // Función para agregar/quitar personaje de favoritos
  void toggleFavorite(int characterId, bool isCurrentlyFavorite) {
    if (isCurrentlyFavorite) {
   
      authService.addFavorite(characterId);
    }
    // Actualizar la UI si es necesario
    setState(() {});
  }
}
