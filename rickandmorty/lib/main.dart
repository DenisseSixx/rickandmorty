import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:rickandmorty/providers/rick_provider.dart';
import 'package:rickandmorty/screens/character_details.dart';
import 'package:rickandmorty/screens/character_list.dart';
import 'package:rickandmorty/screens/episode_details.dart';
import 'package:rickandmorty/screens/episode_screen.dart';
import 'package:rickandmorty/screens/favorites.dart';
import 'package:rickandmorty/screens/home_screen.dart';
import 'package:rickandmorty/screens/pages.dart';
import 'package:rickandmorty/services/services.dart';
void main() => runApp(const AppState());

  class AppState extends StatelessWidget {
  const AppState({super.key});

  @override //ANTES S ECORRIA MYAPP PRIMERO, AHORA ES EL APPSTATE QUE TIENE L PROVIDER, MANEJADOR DE ESTADO.
  Widget build(BuildContext context) {
   
        
      
    return MultiProvider(
      
      providers: [
        ChangeNotifierProvider(  create: (_) => AuthService(), 
        lazy:   false, //normalmetne es perezoso pero aqui hacemos que no sea asi e inicie al inicar la aplicacion
        ), 
        ChangeNotifierProvider(create: (_)=>RickProvider(),
        lazy: false,)
        
      ],
      child: MyApp(),
    );//pide varios providers, depende si son varias peticiones http
  }
  }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Rick and Morty',
       initialRoute: 'login',
      routes: {
       'login': (_)=> LoginPage(),
        'registro': (_)=> RegistroPage(),
        'home': (_)=> HomeScreen(),
        'checking': (_)=> CheckAuthScreen(),
        'details': (_) => CharacterListScreen(p: []),
        'personaje':(_)=>CharacterScreen(Detalles: [], detalles: [],),
        'episodios':(_)=>EpisodeListScreen(epi: [],),
        'epidetail':(_)=>EpisodeScreen(Det: []),
      'favoritos':(_)=>FavoriteCharactersScreen()

       // 'chatacter':()=> CharacterScreen(a: [],)
      },
      theme:ThemeData(
         brightness: Brightness.dark ,
        useMaterial3: true,
      ),
     
    
    // ),
    );
  }
}
