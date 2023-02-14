import 'package:chat/global/environments.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;


class ChatService with ChangeNotifier{

  Usuario? usuarioPara;


  Future getChat(String usuarioID) async{
    String? token = await AuthService.getToken();
    final resp = await http.get(Uri.parse("${Environment.apiUrl}/mensajes/$usuarioID"),
      headers: {
          "Content-Type":"application/json",
          "x-token": token!
        }
    );

    final mensajesResp = MensajesResponse.fromRawJson(resp.body);
    return mensajesResp.mensajes;
  }
}