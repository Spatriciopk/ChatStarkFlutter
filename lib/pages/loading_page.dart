import 'package:chat/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/socket_service.dart';


class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
            return const Center(
            child: Text('Espere....'),
          );
        },
  
      ),
    );
  }

  Future checkLoginState(BuildContext context) async{
    final authService = Provider.of<AuthService>(context,listen: false);
    final socketService = Provider.of<SocketService>(context);
    final autenticado = await authService.isLoggedIn();

    if(autenticado){
      //Todo conectar al sockect server
      socketService.connect();
      Navigator.pushReplacement(context, 
        PageRouteBuilder(
          pageBuilder: (_,__,___) =>UsuariosPage(),
          transitionDuration: Duration(milliseconds: 0)
        ));
    }
    else{
        Navigator.pushReplacement(context, 
        PageRouteBuilder(
          pageBuilder: (_,__,___) =>LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
        ));
    }

  }

}