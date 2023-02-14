import 'package:chat/global/environments.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/models/usuarios_response.dart';
import 'package:chat/services/auth_service.dart';
import "package:http/http.dart" as http;


class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    String? token = await AuthService.getToken();
    try {
      final resp = await http.get(Uri.parse("${Environment.apiUrl}/usuarios"),
        headers: {
          "Content-Type":"application/json",
          "x-token": token!
        }
      );
      final usuarioResponse = UsuariosResponse.fromRawJson(resp.body);
      return usuarioResponse.usuarios;

    } catch (e) {
      return [];
    } 
  }
}