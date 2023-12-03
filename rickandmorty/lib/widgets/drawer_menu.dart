import 'package:flutter/material.dart';
import 'package:rickandmorty/models/character_response.dart';
import 'package:rickandmorty/screens/character_details.dart';

class MenuDrawer extends StatelessWidget {
  final List<Character> per;
  const MenuDrawer({super.key, required this.per});

  @override
  Widget build(BuildContext context) {
return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children:  <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Text(
            'Drawer Header',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Personajes'),
          onTap: () {
            Navigator.pushNamed(context, 'details', arguments: per);

          },
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Capitulos'),
          onTap: (){
            Navigator.pushNamed(context, 'episodios');
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Locaciones'),
        ),
      ],
    ),
);
  
  }
}