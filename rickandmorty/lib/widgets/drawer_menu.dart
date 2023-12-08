import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rickandmorty/models/character_response.dart';

import '../services/auth_services.dart';


class MenuDrawer extends StatelessWidget {
  final List<Character> per;
  const MenuDrawer({super.key, required this.per});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children:  <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Text(
            'WikiRick',
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
          leading: Icon(Icons.tv),
          title: Text('Capitulos'),
          onTap: (){
            Navigator.pushNamed(context, 'episodios');
          },
        ),
     
      
        ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sing out'),
          onTap: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          }

        ),
      ],
    ),
);
  
  }
}