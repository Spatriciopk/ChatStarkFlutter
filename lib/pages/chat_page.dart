import 'dart:io';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/chat_service.dart';


class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

// para utilziar animaciones dver ser con with TickerProviderStateMixin
class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;
  List<ChatMessage> _messages = [];
  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;
  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context,listen: false);
    socketService = Provider.of<SocketService>(context,listen: false);
    authService= Provider.of<AuthService>(context,listen: false);
    socketService!.socket.on("mensaje-personal", (data) => _escucharMensaje(data));
    _cargarHistorial(chatService!.usuarioPara!.uid);
  }

  void _cargarHistorial(String usuarioId) async{
    List<Mensaje> chat = await chatService!.getChat(usuarioId);
    final history = chat.map(
      (msg) => ChatMessage(
        texto: msg.mensaje, 
        uid: msg.de, 
        animationController: AnimationController(vsync: this,duration: Duration(milliseconds: 0))..forward()));

    setState(() {
      _messages.insertAll(0, history);
    });
  
  }

  void _escucharMensaje(dynamic payload){
      ChatMessage message = ChatMessage(
      texto: payload["mensaje"], 
      uid: payload["de"], 
      animationController: AnimationController(vsync: this,duration: Duration(milliseconds: 300)));
      setState(() {
        _messages.insert(0,message);
      });
      message.animationController.forward();
  }



  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService!.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(usuarioPara!.nombre.substring(0,2),style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blueAccent[100],
              maxRadius: 14,
            ),
            const SizedBox(height: 3,),
            Text(usuarioPara.nombre,style: TextStyle(color:Colors.black87,fontSize: 12),)
          ],
        
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, index) => _messages[index],
                //para hacer el scroll hacia arriba
                reverse: true,
                )
              ),
              const Divider(height: 1,),
              Container(
                color: Colors.white,
                child: _inputChat(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            //flexible par q tome el tamaño completo
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit ,
                onChanged: (value) {
                  //Todo Cuando hay un valor para poder enviar el mensaje
                  setState(() {
                    if(value.trim().length > 0){
                      _estaEscribiendo = true;
                    }
                    else{
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: "Enviar mensaje"
                  ),
                focusNode: _focusNode,
              ),
            ),
            //Boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
              ?CupertinoButton(
                child: Text("Enviar"), 
                onPressed: _estaEscribiendo 
                    ? () => _handleSubmit(_textController.text.trim())
                    : null
                )
              : Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    //para quitar la iluminacion cuando se clikea
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.send,),
                    onPressed: _estaEscribiendo 
                    ? () => _handleSubmit(_textController.text.trim())
                    : null
                    ),
                ),
              )
              ,
            )
          ],
        ),
      )
    
    );
  }

  _handleSubmit(String texto){
    if(texto.length == 0) return ; // para evitar q presionen enter con texto en blanco
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      texto: texto, 
      uid: authService!.usuario!.uid,
      animationController: AnimationController(vsync: this,duration: Duration(milliseconds: 400)),
      
      );
    //para agregar al inicio
    _messages.insert(0,newMessage);
    //para empezar la animacion
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo=false;
    });

    socketService!.emit("mensaje-personal",{
      'de':authService!.usuario!.uid,
      'para':chatService!.usuarioPara!.uid,
      'mensaje':texto
    });

    
  }
  @override
  void dispose() {
    // TODO: implement dispose
    //Todo off del socket , cancelar la escucha del socket en partilar
    
    //todo limpiar los controladores d elos mensajes por liberar memoria
    for (ChatMessage message in _messages){
      //limpiar el controlador 
      message.animationController.dispose();
    }

    //descoenctarnos del canal para evitar el consumo de data o itnernet
    socketService!.socket.off("mensaje-personal");
    super.dispose();

  }
}