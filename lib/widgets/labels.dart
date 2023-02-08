import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({super.key, required this.ruta, required this.titulo, required this.subtitulo});

  final String ruta;
  final String titulo;
  final String subtitulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("$titulo", style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w300),),
          SizedBox(height: 10,),
          GestureDetector(
          onTap: () {
            print("Tap");
            Navigator.pushReplacementNamed(context,ruta);
          },
          child: Text("$subtitulo",style: 
          TextStyle(color: Colors.blue[600],fontSize: 18,fontWeight: FontWeight.bold),)),

        
        ],
      ),
    );
  }
}