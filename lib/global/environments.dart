import 'dart:io';

class Environment {
  /*
  Recordar para android usar direccion ip d ela maquina apra ios si funciona con local host
    "http://192.168.10.143:3000/api/login/" : "http://localhost:3000/api/login/renew";
   */
  static String apiUrl = Platform.isAndroid ? "http://192.168.10.143:3000/api" : "http://localhost:3000/api";
  static String socketURL =  Platform.isAndroid ? "http://192.168.10.143:3000" : "http://localhost:3000";

}