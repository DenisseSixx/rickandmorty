import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/providers/rick_provider.dart';
import 'package:rickandmorty/widgets/widgets.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final rickProvider = Provider.of<RickProvider>(context);
    
    return Scaffold(
     
 appBar: AppBar(

     flexibleSpace: Image(
          image: AssetImage('assets/BAR.png'),
          fit: BoxFit.fitHeight) ,        
      
        elevation: 0,
        actions: [
          /*IconButton(
              icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          
          )*/
          
        ],
        title: const Center(
        //  child: Text('Personajes'),
        ),
      ),
      body: Column(
      

        children: [ 
         

          Image.asset('assets/bar.jpg'),
          
       CharacterSlider(
            characters: rickProvider.characters),
             Image.asset('assets/rmorty.gif'),
          ],
          
      ),
      drawer: MenuDrawer(per: rickProvider.characters),
    );
  }
}