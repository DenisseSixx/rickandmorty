import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/providers/rick_provider.dart';
import 'package:rickandmorty/screens/character_details.dart';
import 'package:rickandmorty/screens/character_list.dart';
import 'package:rickandmorty/screens/home_screen.dart';

void main() => runApp(const AppState());

  class AppState extends StatelessWidget {
  const AppState({super.key});

  @override //ANTES S ECORRIA MYAPP PRIMERO, AHORA ES EL APPSTATE QUE TIENE L PROVIDER, MANEJADOR DE ESTADO.
  Widget build(BuildContext context) {
   
        
      
    return MultiProvider(
      
      providers: [
        ChangeNotifierProvider(
          //AVISA QUE HAY CAMBI ASI QUE SE ACTUALIZA,
          create: (_) => RickProvider(),
          lazy:
              false, //normalmetne es perezoso pero aqui hacemos que no sea asi e inicie al inicar la aplicacion
        )
      ],
      child: MyApp(),
    ); //pide varios providers, depende si son varias peticiones http
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Rick and Morty',
       initialRoute: 'a',
      routes: {
        'a':(_)=> HomeScreen(),
        'details':(_)=> CharacterListScreen(p: [],),
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

