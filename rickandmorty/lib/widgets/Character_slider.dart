import 'package:flutter/material.dart';
import 'package:rickandmorty/models/character_response.dart';



class CharacterSlider extends StatelessWidget {
   final List<Character> characters;
  final String? name;
  const CharacterSlider({super.key, required this.characters, this.name});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.30,
      color: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Personajes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400, 
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: characters.length,
              itemBuilder: (_, int index) => _MoviePoster(character: characters[index]),
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Character character;
  const _MoviePoster({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () =>  Navigator.pushNamed(context, 'personaje', arguments: character),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(character.image),
               //image: NetworkImage('assets/no-image.jpg'),
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            character.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}