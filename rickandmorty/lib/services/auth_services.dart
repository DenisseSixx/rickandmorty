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

    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(authData));

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
Future<String?> getUserId() async {
  try {
    final token = await readToken();

    if (token != null) {
      print('Decoded Token: $token');

      // Decodificar el token para obtener la información del usuario
      final Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))),
      );

      // Asumimos que el ID del usuario está presente en el token
      if (decodedToken.containsKey('sub')) {
        return decodedToken['sub'];
      } else if (decodedToken['email'] is List && decodedToken['email'].isNotEmpty) {
        return decodedToken['email'][0].toString();  // Tomamos el primer correo electrónico si hay varios
      }
    }
  } catch (e) {
    print('Error al obtener el ID del usuario: $e');
  }

  return null;
}










Future<void> agregarPersonajeFavorito(String userId, int characterId) async {
  try {
    final Map<String, dynamic> data = {
      'id': 0,
      'userId': userId,
      'characterId': characterId,
    };

    final url = Uri.http(_baseUrl, '/api/Cuentas/Favorito');

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    print('Código de estado de la respuesta: ${resp.statusCode}');
    print('Respuesta del servidor: ${resp.body}');

    if (resp.statusCode == 200) {
      print('Personaje favorito agregado con éxito');
    } else {
      print('Error al agregar personaje favorito. Detalles: ${resp.body}');
    }
  } catch (error) {
    print('Excepción al agregar personaje favorito: $error');
  }
}

 Future<void> eliminarPersonajeFavorito(String userId, int characterId) async {
  try {
    final urlb = Uri.http(_baseUrl, '/api/Cuentas/ObtenerPersonajesFavoritos/$userId');
    print('URL de solicitud: $urlb');

    final resp2 = await http.get(
      urlb,
      headers: {"Content-Type": "application/json"},
    );

    final List<dynamic> userDataList = json.decode(resp2.body);
    print('userda');
    print(userDataList);

    // Recorrer la lista de userData para buscar coincidencias
    for (final userData in userDataList) {
      int registroId = userData['id'];

      // Verificar si userId y gameId coinciden con los de la base de datos
      if (userData['userId'] == userId && userData['characterId'] == characterId) {
        final Map<String, dynamic> data = {
          'id': registroId,
          'userId': userId,
          'characterId': characterId,
        };

        final url = Uri.http(_baseUrl, '/api/Cuentas/EliminarPersonajeFavorito');

        final resp = await http.delete(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode(data),
        );

        if (resp.statusCode == 200) {
          print('Personaje favorito eliminado con éxito');
        } else {
          print('Error al eliminar personaje favorito. Código de estado: ${resp.statusCode}');
        }
      } else {
        print('No se encontró coincidencia en la base de datos');
      }
    }
  } catch (error) {
    print('Excepción al eliminar personaje favorito: $error');
  }
}



  Future<List<Map<String, dynamic>>> obtenerPersonajesFavoritos(String userId) async {
  try {
    final url = Uri.http(_baseUrl, '/api/Cuentas/ObtenerPersonajesFavoritos/$userId');

    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (resp.statusCode == 200) {
      final List<dynamic> data = json.decode(resp.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      print('Error al obtener personajes favoritos. Código de estado: ${resp.statusCode}');
      return [];
    }
  } catch (error) {
    print('Excepción al obtener personajes favoritos: $error');
    return [];
  }
}


Future<bool> existeJPersonajeFavorito(String userId, int characterId) async {
  try {
    final url = Uri.http(_baseUrl, '/api/Cuentas/$userId');

    final resp = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> userDataList = json.decode(resp.body);

      // Verificar si existe un juego favorito con el userId y gameId proporcionados
      return userDataList.any((userData) =>
          userData['userId'] == userId && userData['characterId'] == characterId);
    } else {
      print(
          'Error al verificar personaje favorito. Código de estado: ${resp.statusCode}');
      return false;
    }
  } catch (error) {
    print('Excepción al verificar personaje favorito: $error');
    return false;
  }
}
  }
