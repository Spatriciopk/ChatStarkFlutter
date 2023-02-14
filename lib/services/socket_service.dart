import 'package:chat/global/environments.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  IO.Socket get socket => _socket!;
  Function get emit => _socket!.emit;



  void connect() async{
    
    final token = await AuthService.getToken();


    // Dart client
    _socket = IO.io(Environment.socketURL, {
      'transports': ['websocket'],
      'autoConnect': true,
      //force new gerena una nueva isntancia un nuevo cliente
      'forceNew':true,
      //mandar el token extraheaders recibe un mapa
      'extraHeaders':{
        'x-token':token
      }

    });

    _socket!.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket!.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

  }

  void disconnect(){
    _socket!.disconnect();
  }

}