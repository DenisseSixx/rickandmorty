import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'loginnenis.somee.com';
  //final String _firebaseToken = 'AIzaSyCD36g1c5N9WPp4PCmVwt2jEzdWIGtglso';

  final storage = new FlutterSecureStorage();

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      //'returnSecureToken': true
    };

    final url = Uri.http(_baseUrl, '/api/Cuentas/registrar');

    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(authData));
    print('Response body; ${resp.body}');
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('token')) {
      // Token hay que guardarlo en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['token']);
      // decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };
    final url = Uri.http(_baseUrl, '/api/Cuentas/Login');

    //final url2 = Uri.https(_baseUrl, '/Prueba/on');

    /*final resp2 = await http.get(url2, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    });*/

    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(authData));

    /*final resp = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: json.encode(authData));*/

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('token')) {
      // Token hay que guardarlo en un lugar seguro
      // decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['token']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

//////////////
  Future<void> addFavorite(int characterId) async {
    try {
      final token = await readToken();
      final url = Uri.http(_baseUrl, '/api/Cuentas/Favorito');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'characterId': characterId}),
      );

      if (response.statusCode == 200) {
        print('Personaje agregado a favoritos');
      } else {
        print('Error al agregar personaje a favoritos');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<List<int>> getFavorites() async {
    try {
      final token = await readToken();
      final url = Uri.http(_baseUrl, '/api/Cuentas/Favorito');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<int> favorites =
            data.map((fav) => fav['characterId'] as int).toList();
        return favorites;
      } else {
        print('Error al obtener favoritos');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }
}
