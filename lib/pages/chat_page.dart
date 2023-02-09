import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text("Te",style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blueAccent[100],
              maxRadius: 14,
            ),
            const SizedBox(height: 3,),
            Text("Melissa Flores",style: TextStyle(color:Colors.black87,fontSize: 12),)
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
      uid: "123",
      animationController: AnimationController(vsync: this,duration: Duration(milliseconds: 400)),
      
      );
    //para agregar al inicio
    _messages.insert(0,newMessage);
    //para empezar la animacion
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo=false;
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
  
    super.dispose();

  }
}