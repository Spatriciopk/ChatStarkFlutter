import 'package:chat/models/usuario.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/socket_service.dart';


class UsuariosPage extends StatefulWidget {



  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  final usuarioService = UsuariosService();
  List<Usuario> usuarios=[];
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  

  //para inicializar las cosas , datos etc
  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }
  
  
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context,listen: false);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title:  Text("${usuario!.nombre}",style: TextStyle(color: Colors.black54),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app,color: Colors.black54),
          onPressed: () {
            //Todo desconectar del socket server
            socketService.disconnect();
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, "login");
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
            ?Icon(Icons.offline_bolt,color: Colors.blue[400])
            : Icon(Icons.offline_bolt,color: Colors.red[400]),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        child: _listViewUsuarios(),
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check,color: Colors.blue[400],),
          waterDropColor: Colors.blue,
        ),
        enablePullDown: true,
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => _usuarioListTile(usuarios[index]), 
      separatorBuilder: (context, index) => const Divider(), 
      itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(usuario.nombre.substring(0,2)),
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context,listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, "chat");
        },
      );
  }

  //aqui se puede ejecutar el metodo de refresco o loq s e mande a cargar cuando jalo la pantalla
  _cargarUsuarios() async{

    usuarios = await usuarioService.getUsuarios();
    setState(() {
      
    });

    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

}