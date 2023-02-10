import 'dart:convert';

import 'package:chat/global/environments.dart';
import 'package:chat/models/login_response.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import '../models/usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class AuthService with ChangeNotifier{

  Usuario? usuario;
  bool _autenticando = false;


  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  
  set autenticando(bool valor){
    _autenticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estática
  static Future<String?> getToken() async{
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: "token");
  }

  static Future<void> deleteToken() async{
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: "token");
  }


  //peticiones http por eso va async
  //va a regresar un valor booleano
  Future <bool> login({ required String email, required String password}) async{

    autenticando=true;
    final data = {
      "email":email,
      "password":password
    };
    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login'),
      body: jsonEncode(data),
      headers: {
        "Content-Type":"application/json"
      }
    );

    //200 significa que todo esta bien
    autenticando = false;
    if(resp.statusCode == 200){
      final loginResponse = LoginResponse.fromRawJson(resp.body);
      usuario = loginResponse.usuario;
      //TODO Guardar token en lugar seguro
      await _guardarToken(loginResponse.token);
      return true;
    }
    else{
      return false;
    }
  }

  Future  register({ required String nombre,required String email, required String password}) async{
    autenticando=true;
    final data = {
      "nombre":nombre,
      "email":email,
      "password":password
    };
    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login/new'),
      body: jsonEncode(data),
      headers: {
        "Content-Type":"application/json"
      }
    );
    autenticando = false;
    if(resp.statusCode == 200){
      final loginResponse = LoginResponse.fromRawJson(resp.body);
      usuario = loginResponse.usuario;
      //TODO Guardar token en lugar seguro
      await _guardarToken(loginResponse.token);
      return true;
    }
    else{
      final respBody = jsonDecode(resp.body);
      return respBody["msg"];
    }


  }

  //http://localhost:3000/api/login/renew
  Future<bool> isLoggedIn() async{
    final token = await _storage.read(key: "token") ?? "" ;
    final resp = await http.get(Uri.parse('${Environment.apiUrl}/login/renew'),
      headers: {
        "Content-Type":"application/json",
        "x-token":token
      }
    );
    if(resp.statusCode == 200){
      final loginResponse = LoginResponse.fromRawJson(resp.body);
      usuario = loginResponse.usuario;
      //TODO Guardar token en lugar seguro
      await _guardarToken(loginResponse.token);
      return true;
    }
    else{
      logout();
      return false;
    }
  }


  Future _guardarToken( String token) async{
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async{
    // Delete value
    await _storage.delete(key: "token");
  }

}