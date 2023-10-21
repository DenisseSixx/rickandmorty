/*import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:rickandmorty/models/character.dart';
import 'package:rickandmorty/models/character_response.dart';

class CardSwiper extends StatelessWidget {
  final List<Character> characters;
  const CardSwiper({super.key, required this.characters});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; //para determinar el tamano de la pantalla 

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: characters.length, //numero de trajetas que va a tener
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (_, int index) {
          final character = characters[index];
          print(character.image);
          print(character.fullPosterImg);
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: characters),
            child: ClipRRect(  //para ponerlo redondeado 
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(character.fullPosterImg),
              ),
            ),
          );
        },
      ),
    );
  }
}*/